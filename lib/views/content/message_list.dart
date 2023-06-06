import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../../widgets/image_message.dart';
import 'package:intl/intl.dart';
import '../../widgets/message.dart';

class MessageList extends StatefulWidget {
  final ScrollController scrollController;
  const MessageList({super.key, required this.scrollController});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<Widget> renderMessageList(List<MessageModel> messageData) {
    List<Widget> messages = [];
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    for (final message in messageData) {
      final bool isLeft = message.sendBy != uid;
      final time = DateFormat.jm().format(message.sentAt);

      if (message.img == null) {
        messages.add(
          Message(
            isLeft: isLeft,
            message: message.msg ?? "",
            time: time,
          ),
        );
      } else {
        messages.add(ImageMessage(
          isLeft: isLeft,
          imgUrl: message.img ?? "",
          time: time,
        ));
      }
    }
    return messages;
  }

  void _scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 100));
    widget.scrollController
        .jumpTo(widget.scrollController.position.maxScrollExtent + 250);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollDown();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final messageData = Provider.of<List<MessageModel>?>(context) ?? [];

    renderMessageList(messageData);

    return ListView(
      shrinkWrap: true,
      controller: widget.scrollController,
      children: [
        ...renderMessageList(messageData),
      ],
    );
  }
}
