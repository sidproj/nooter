import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/friend.dart';
import '../../widgets/chat.dart';
import '../../widgets/theme_colors.dart';

class ConnectionList extends StatelessWidget {
  const ConnectionList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Friend>? friends = Provider.of<List<Friend>?>(context);

    List<Chat>? renderChat() {
      final List<Chat> chats = [];
      int count = 0;

      for (Friend friend in friends ?? []) {
        count++;
        chats.add(Chat(
          type: 7,
          display: friend.display_name,
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
                "No connections",
                style: TextStyle(
                  color: ThemeColors.accentColor2,
                ),
              ),
            ),
          ],
    );
  }
}
