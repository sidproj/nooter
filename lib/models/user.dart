import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fname;
  final String lname;
  final String? profile;
  final String email;
  final String description;
  final String display_name;

  UserModel({
    required this.display_name,
    required this.description,
    required this.fname,
    required this.lname,
    required this.profile,
    required this.email,
    required this.id,
  });

  factory UserModel.fromMapData(Map<dynamic, dynamic> data, String id) {
    return UserModel(
      fname: data['first_name'],
      lname: data['last_name'],
      profile: data['profile'],
      email: data['email'],
      id: id,
      description: data['description'],
      display_name: data['display_name'],
    );
  }

  static UserModel createFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel.fromMapData(snapshot.data() as Map, snapshot.id);
  }
}
