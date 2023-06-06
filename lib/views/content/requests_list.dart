import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/requests.dart';
import 'package:wagwan/widgets/theme_colors.dart';
import '../../widgets/chat.dart';

class RequestList extends StatelessWidget {
  const RequestList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Requests>? friends = Provider.of<List<Requests>?>(context);

    List<Chat>? renderChat() {
      int count = 0;
      final List<Chat> chats = [];
      for (Requests friend in friends ?? []) {
        count++;
        chats.add(Chat(
          type: 2,
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
                "No requests",
                style: TextStyle(
                  color: ThemeColors.accentColor2,
                ),
              ),
            ),
          ],
    );
  }
}
