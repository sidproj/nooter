import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wagwan/models/friend.dart';

class Requested extends Friend {
  Requested({
    required super.email,
    required super.fname,
    required super.lname,
    required super.profile,
    required super.uid,
    required super.display_name,
    required super.description,
  });

  factory Requested.fromSnapshot(Map<dynamic, dynamic> data, final String uid) {
    return Requested(
      email: data['email'],
      fname: data['first_name'],
      lname: data['last_name'],
      profile: data['profile'],
      uid: uid,
      display_name: data['display_name'],
      description: data['description'],
    );
  }

  static List<Requested> createFromSnapshot(QuerySnapshot snapshot) {
    List<Requested> requesteds = [];

    for (var doc in snapshot.docs) {
      requesteds.add(Requested.fromSnapshot(doc.data() as Map, doc.id));
    }

    return requesteds;
  }
}
