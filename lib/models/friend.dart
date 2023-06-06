import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String email;
  final String fname;
  final String lname;
  final String? profile;
  final String uid;
  final String display_name;
  final String description;

  Friend({
    required this.email,
    required this.fname,
    required this.lname,
    required this.profile,
    required this.uid,
    required this.display_name,
    required this.description,
  });

  factory Friend.fromSnapshotData(
      Map<dynamic, dynamic> data, final String uid) {
    return Friend(
      email: data["email"],
      fname: data["first_name"],
      lname: data["last_name"],
      profile: data["profile"],
      uid: uid,
      display_name: data['display_name'],
      description: data['description'],
    );
  }

  static List<Friend> createFromSnapshot(QuerySnapshot snapshot) {
    List<Friend> friends = [];

    for (var doc in snapshot.docs) {
      friends.add(Friend.fromSnapshotData(doc.data() as Map, doc.id));
    }
    return friends;
  }
}
