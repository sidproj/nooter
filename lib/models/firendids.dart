import 'package:cloud_firestore/cloud_firestore.dart';

class FriendIds {
  final List<String> uids;

  FriendIds(
    this.uids,
  );

  factory FriendIds.fromSnapshot(QuerySnapshot snapshot) {
    List<String> ids = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map;
      ids.add(data['user_id']);
    }
    return FriendIds(ids);
  }
}
