import 'package:cloud_firestore/cloud_firestore.dart';

import 'friend.dart';

class ConnectedFriend extends Friend {
  ConnectedFriend({
    required super.email,
    required super.fname,
    required super.lname,
    required super.profile,
    required super.uid,
    required super.display_name,
    required super.description,
  });

  factory ConnectedFriend.fromMapData(
      Map<dynamic, dynamic> data, final String uid) {
    return ConnectedFriend(
      email: data['email'],
      fname: data['first_name'],
      lname: data['last_name'],
      profile: data['profile'],
      uid: uid,
      display_name: data['display_name'],
      description: data['description'],
    );
  }

  static List<ConnectedFriend> createFromSnapshot(QuerySnapshot snapshot) {
    List<ConnectedFriend> friends = [];

    for (var doc in snapshot.docs) {
      friends.add(ConnectedFriend.fromMapData(doc.data() as Map, doc.id));
    }

    return friends;
  }
}
