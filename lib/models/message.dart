import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final DateTime sentAt;
  final String sendBy;
  final String? msg;
  final String? img;

  MessageModel({
    this.img,
    required this.sentAt,
    required this.sendBy,
    this.msg,
  });

  factory MessageModel.fromMap(final data) {
    return MessageModel(
      sentAt: DateTime.parse(data['sent_at'].toDate().toString()),
      sendBy: data['sent_by'],
      msg: data['text'],
      img: data['image'],
    );
  }

  static List<MessageModel> createMessageModelListFromSnapshot(
      QuerySnapshot snapshot) {
    final List<MessageModel> msgs = [];

    for (final doc in snapshot.docs) {
      msgs.add(MessageModel.fromMap(doc.data() as Map));
    }

    return msgs;
  }
}
