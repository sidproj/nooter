import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectedFriendIds {
  final List<String> uids;

  ConnectedFriendIds(this.uids);

  factory ConnectedFriendIds.fromSnapshot(QuerySnapshot snapshot) {
    List<String> ids = [];
    print("snapshot docs");

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map;
      print(data);
      ids.add(data['user_id']);
    }

    return ConnectedFriendIds(ids);
  }
}
