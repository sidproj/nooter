import 'package:cloud_firestore/cloud_firestore.dart';

import 'friend.dart';

class NonFriend extends Friend {
  NonFriend({
    required super.email,
    required super.fname,
    required super.lname,
    required super.profile,
    required super.uid,
    required super.display_name,
    required super.description,
  });

  factory NonFriend.fromSnapshotData(
      Map<dynamic, dynamic> data, final String uid) {
    return NonFriend(
      email: data['email'],
      fname: data['first_name'],
      lname: data['last_name'],
      profile: data['profile'],
      uid: uid,
      display_name: data['display_name'],
      description: data['description'],
    );
  }

  static List<NonFriend> createFromSnapshot(QuerySnapshot snapshot) {
    List<NonFriend> nonFriends = [];

    for (var doc in snapshot.docs) {
      nonFriends.add(NonFriend.fromSnapshotData(doc.data() as Map, doc.id));
    }

    return nonFriends;
  }
}
