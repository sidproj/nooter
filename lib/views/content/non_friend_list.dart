import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/newPeople.dart';
import '../../widgets/chat.dart';
import '../../widgets/theme_colors.dart';

class NonFriendList extends StatelessWidget {
  const NonFriendList({super.key});

  @override
  Widget build(BuildContext context) {
    List<NonFriend>? friends = Provider.of<List<NonFriend>?>(context);

    List<Chat>? renderChat() {
      final List<Chat> chats = [];
      int count = 0;
      for (NonFriend friend in friends ?? []) {
        count++;
        chats.add(Chat(
          type: 0,
          display: "${friend.fname} ${friend.lname}",
          subDisplay: friend.email,
          uid: friend.uid,
          profile: friend.profile,
          description: friend.description,
        ));
      }
      if (count == 0) return null;
      return chats;
    }

    return ListView(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      children: renderChat() ??
          [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "No Users",
                style: TextStyle(
                  color: ThemeColors.accentColor2,
                ),
              ),
            ),
          ],
    );
  }
}
