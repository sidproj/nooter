import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wagwan/models/firendids.dart';
import 'package:wagwan/models/friend.dart';
import 'package:wagwan/models/message.dart';
import 'package:wagwan/models/newPeople.dart';
import 'package:wagwan/models/request_ids.dart';
import 'package:wagwan/models/requested.dart';
import 'package:wagwan/models/requested_ids.dart';
import 'package:wagwan/models/requests.dart';
import 'package:wagwan/models/user.dart';

class DatabaseService {
  final String? uid;

  DatabaseService(this.uid);

  //user collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  //messages collection reference
  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection("messages");

  //rooms collection reference
  final CollectionReference roomCollections =
      FirebaseFirestore.instance.collection("rooms");

  //image storage reference
  final storageRef = FirebaseStorage.instance.ref();

  //----------------------------------------Upload profile pic----------------------------------------//

  void uploadProfilePic(File imageFile) async {
    final profileStorageRef = storageRef.child('/$uid').child('/profile');
    await profileStorageRef.putFile(imageFile);
    String url = await profileStorageRef.getDownloadURL();
    await userCollection.doc(uid).update({'profile': url});
  }

  void sendImageViaMessage(File imageFile, String reciverUid) async {
    String msgDocId = _generateMsgDocId(reciverUid) + DateTime.now().toString();
    final messageImageStorageRef =
        storageRef.child('/$uid').child('/$msgDocId');

    await messageImageStorageRef.putFile(imageFile);
    print("image uploaded!");
    String url = await messageImageStorageRef.getDownloadURL();
    print(url);
    sendMessage(null, reciverUid, url);
  }

  //----------------------------------------End upload profile pic----------------------------------------//

  //----------------------------------------User functions----------------------------------------//

  // add user profile when user registers for the first time.
  Future addUserProfile(String fname, String lname) async {
    final curuser = FirebaseAuth.instance.currentUser;
    return await userCollection.doc(uid).set({
      'first_name': fname,
      'last_name': lname,
      'profile': null,
      'description': "What's going on my guys?",
      'email': curuser?.email,
      "display_name": '$fname $lname',
    });
  }

  //sends friend request to another user of uid : reciverUid
  void sendFriendRequest(String reciverUid) async {
    //doc refs
    final currentUserDocRef = userCollection.doc(uid);

    //doc refs
    final newUserDocRef = userCollection.doc(reciverUid);

    await currentUserDocRef.collection("requested").doc(reciverUid).set({
      "reciver_id": reciverUid,
    });

    await newUserDocRef.collection("requests").doc(uid).set({"sender_id": uid});
  }

  //accept requeset
  void acceptFriendRequest(String reciverUid) async {
    final currentUserRef = userCollection.doc(uid);
    final newUserRef = userCollection.doc(reciverUid);

    await currentUserRef.collection('requests').doc(reciverUid).delete();
    await newUserRef.collection('requested').doc(uid).delete();

    await currentUserRef
        .collection('friends')
        .doc(reciverUid)
        .set({"user_id": reciverUid});
    await newUserRef.collection('friends').doc(uid).set({"user_id": uid});
  }

  //gets stream of snapshots of user's data
  Stream<UserModel> get user {
    return userCollection
        .doc(uid)
        .snapshots()
        .map((snapshot) => UserModel.createFromSnapshot(snapshot));
  }

  Stream<QuerySnapshot> get notification {
    return userCollection.doc(uid).collection("notification").snapshots();
  }

  void changeDisplayName(String displayName) async {
    await userCollection.doc(uid).update({
      "display_name": displayName,
    });
  }

  void changeDescription(String description) async {
    await userCollection.doc(uid).update({
      "description": description,
    });
  }

  //----------------------------------------End user functions----------------------------------------//

  //----------------------------------------Friend----------------------------------------//

  //get stream of ids of friends
  Stream<FriendIds> friendsIds(String fuid) {
    // fuid = "XIqXRfZg7Lbhkgbr8CK6b3s4qe23";
    return userCollection
        .doc(fuid)
        .collection("friends")
        .snapshots()
        .map((snapshot) => FriendIds.fromSnapshot(snapshot));
  }

  Stream<List<String>> connectedFriends(String uid) {
    return userCollection
        .doc(uid)
        .collection("friends")
        .snapshots()
        .map((snapshot) => FriendIds.fromSnapshot(snapshot).uids);

    // return FriendIds.fromSnapshot(snapshot);
  }

  // get stream of list of friends
  Stream<List<Friend>> friend(FriendIds friendIds) {
    final ids = [...friendIds.uids, "Testing"];
    return userCollection
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map((snapshot) {
      return Friend.createFromSnapshot(snapshot);
    });
  }

  //get stream of list of people who are not friends
  Stream<List<NonFriend>> nonFriend(FriendIds friendIds) {
    List<String> ids = [
      ...friendIds.uids,
      FirebaseAuth.instance.currentUser?.uid ?? "Testing"
    ];
    return userCollection
        .where(FieldPath.documentId, whereNotIn: ids)
        .snapshots()
        .map((snapshot) {
      return NonFriend.createFromSnapshot(snapshot);
    });
  }

  //remove friend
  void removeFriend(String reciverUid) {
    userCollection.doc(uid).collection("friends").doc(reciverUid).delete();
    userCollection.doc(reciverUid).collection("friends").doc(uid).delete();
  }

  //remove request
  void removeRequest(String reciverUid) {
    userCollection.doc(uid).collection("requests").doc(reciverUid).delete();
    userCollection.doc(reciverUid).collection("requested").doc(uid).delete();
  }

  //remove requested
  void removeRequested(String reciverUid) {
    userCollection.doc(uid).collection("requested").doc(reciverUid).delete();
    userCollection.doc(reciverUid).collection("requests").doc(uid).delete();
  }

  //----------------------------------------End Friend----------------------------------------//

  //----------------------------------------Requested----------------------------------------//

  //get stream of ids of requested
  Stream<RequestedIds> requestedIds() {
    return userCollection
        .doc(uid)
        .collection("requested")
        .snapshots()
        .map((snapshot) => RequestedIds.fromSnapshot(snapshot));
  }

  //get stream of list of people who are requested
  Stream<List<Requested>> requesteds(RequestedIds reqIds) {
    List<String> ids = [...reqIds.uids, "Testing"];
    return userCollection
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map((snapshot) => Requested.createFromSnapshot(snapshot));
  }

  //----------------------------------------End Requested----------------------------------------//

  //----------------------------------------Requests----------------------------------------//

  Stream<RequestIds> requestIds() {
    return userCollection
        .doc(uid)
        .collection("requests")
        .snapshots()
        .map((snapshot) => RequestIds.fromSnapshot(snapshot));
  }

  Stream<List<Requests>> requests(RequestIds reqIds) {
    List<String> ids = [...reqIds.uids, "Testing"];
    return userCollection
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map((snapshot) => Requests.createFromSnapshot(snapshot));
  }

  //----------------------------------------End Requests----------------------------------------//

  // generates msg document id for 2 users
  String _generateMsgDocId(String reciverUid) {
    String msgDocId = "";
    String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (currentUserUid.compareTo(reciverUid) > 0) {
      msgDocId = currentUserUid + reciverUid;
    } else {
      msgDocId = reciverUid + currentUserUid;
    }
    return msgDocId;
  }

  // sends message from logged in user to the user of id : reciverUid
  void sendMessage(String? message, String reciverUid, String? img) async {
    String msgDocId = _generateMsgDocId(reciverUid);
    await messageCollection.doc(msgDocId).collection("messages").add({
      "text": message,
      "sent_at": DateTime.now(),
      "sent_by": FirebaseAuth.instance.currentUser?.uid,
      "image": img,
    });
    final user = await userCollection.doc(uid).get();
    final userData = user.data() as Map;

    final notificationDocs =
        await userCollection.doc(reciverUid).collection("notification").get();

    notificationDocs.docs.forEach((doc) {
      if (doc.id != "Testing") doc.reference.delete();
    });

    print(userData);
    await userCollection.doc(reciverUid).collection("notification").add({
      'display_name': userData['display_name'],
      'message': message,
    });
  }

  void sendMessageByRoom(String message, String reciverUid, String img) async {
    String roomDocId = _generateMsgDocId(reciverUid);

    await roomCollections.doc(roomDocId).collection("messages").add(
      {
        "text": message,
        "sent_at": DateTime.now(),
        "sent_by": FirebaseAuth.instance.currentUser?.uid,
        "image": img,
      },
    );
  }

  // get stream of all the messages from one selected user with id : reciverUid
  Stream<List<MessageModel>> getMessages(String reciverUid) {
    String msgDocId = _generateMsgDocId(reciverUid);

    return messageCollection
        .doc(msgDocId)
        .collection("messages")
        .orderBy("sent_at", descending: false)
        .limit(100)
        .snapshots()
        .map(
      (snapshot) {
        return MessageModel.createMessageModelListFromSnapshot(snapshot);
      },
    );
  }

  // pending
  Stream<QuerySnapshot> getLastMessage(String reciverUid) {
    String msgDocId = _generateMsgDocId(reciverUid);

    return messageCollection
        .doc(msgDocId)
        .collection("messages")
        .orderBy("sent_at", descending: false)
        .snapshots();
  }
}
