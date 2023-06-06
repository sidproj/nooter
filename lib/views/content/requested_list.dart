import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/requested.dart';
import '../../widgets/chat.dart';
import '../../widgets/theme_colors.dart';

class RequestedList extends StatelessWidget {
  const RequestedList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Requested>? friends = Provider.of<List<Requested>?>(context);

    List<Chat>? renderChat() {
      final List<Chat> chats = [];
      int count = 0;
      for (Requested friend in friends ?? []) {
        count++;
        chats.add(Chat(
          type: 3,
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
                "No requested",
                style: TextStyle(
                  color: ThemeColors.accentColor2,
                ),
              ),
            ),
          ],
    );
  }
}
