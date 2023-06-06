import 'package:cloud_firestore/cloud_firestore.dart';

class RequestIds {
  final List<String> uids;

  RequestIds(
    this.uids,
  );

  factory RequestIds.fromSnapshot(QuerySnapshot snapshot) {
    List<String> test = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map;
      test.add(data['sender_id']);
    }
    return RequestIds(test);
  }
}
