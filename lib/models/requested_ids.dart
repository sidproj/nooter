import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedIds {
  final List<String> uids;

  RequestedIds(
    this.uids,
  );

  factory RequestedIds.fromSnapshot(QuerySnapshot snapshot) {
    List<String> test = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map;
      test.add(data['reciver_id']);
    }
    return RequestedIds(test);
  }
}
