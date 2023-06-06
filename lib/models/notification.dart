import 'package:cloud_firestore/cloud_firestore.dart';

class UserNotification {
  final String fname;
  final String lname;
  final String? profile;
  final String uid;
  final String message;

  UserNotification({
    required this.fname,
    required this.lname,
    required this.profile,
    required this.uid,
    required this.message,
  });

  factory UserNotification.fromMapData(Map<dynamic, dynamic> data) {
    return UserNotification(
      fname: data['frist_name'],
      lname: data['last_name'],
      profile: data['profile'],
      uid: data['uid'],
      message: data['message'],
    );
  }

  static List<UserNotification> createFromSnapshot(QuerySnapshot snapshot) {
    List<UserNotification> userNotifications = [];

    for (final doc in snapshot.docs) {
      userNotifications.add(UserNotification.fromMapData(doc.data() as Map));
    }
    return userNotifications;
  }
}
