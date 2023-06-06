import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/widgets/message.dart';

class Messages extends StatefulWidget {
  final ScrollController scrollController;
  const Messages({super.key, required this.scrollController});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<Widget> buildMessages(QuerySnapshot<Object?>? snapshots) {
    List<Widget> widgets = [];
    String curuser = FirebaseAuth.instance.currentUser?.uid ?? "";
    snapshots?.docs.forEach((data) {
      bool isLeft = (data['sent_by'] != curuser);
      widgets.add(Message(isLeft: isLeft, message: data['text'], time: "time"));
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final snapshots = Provider.of<QuerySnapshot?>(context);

    return ListView(
        controller: widget.scrollController,
        children: buildMessages(snapshots));
  }
}
