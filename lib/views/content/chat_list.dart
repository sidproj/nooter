import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/friend.dart';
import '../../widgets/chat.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    List<Friend>? friends = Provider.of<List<Friend>?>(context);

    List<Widget> renderChatList() {
      List<Widget> chats = [];

      for (Friend friend in friends ?? []) {
        chats.add(Chat(
          type: 5,
          display: friend.display_name,
          subDisplay: friend.email,
          profile: friend.profile,
          uid: friend.uid,
          description: friend.description,
        ));
      }
      return chats;
    }

    return ListView(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      children: renderChatList(),
    );
  }
}
