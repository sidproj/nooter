import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wagwan/models/friend.dart';

class Requests extends Friend {
  Requests({
    required super.email,
    required super.fname,
    required super.lname,
    required super.profile,
    required super.uid,
    required super.display_name,
    required super.description,
  });

  factory Requests.fromSnapshot(Map<dynamic, dynamic> data, final String uid) {
    return Requests(
      email: data['email'],
      fname: data['first_name'],
      lname: data['last_name'],
      profile: data['profile'],
      uid: uid,
      display_name: data['display_name'],
      description: data['description'],
    );
  }

  static List<Requests> createFromSnapshot(QuerySnapshot snapshot) {
    List<Requests> requestss = [];

    for (var doc in snapshot.docs) {
      requestss.add(Requests.fromSnapshot(doc.data() as Map, doc.id));
    }

    return requestss;
  }
}
