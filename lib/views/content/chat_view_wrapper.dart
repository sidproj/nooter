import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/friend.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/views/content/chat_list.dart';
import 'package:wagwan/widgets/theme_colors.dart';

import '../../models/firendids.dart';

class ChatViewWrapper extends StatefulWidget {
  const ChatViewWrapper({super.key});

  @override
  State<ChatViewWrapper> createState() => _ChatViewWrapperState();
}

class _ChatViewWrapperState extends State<ChatViewWrapper> {
  @override
  Widget build(BuildContext context) {
    FriendIds? f = Provider.of<FriendIds?>(context) ?? FriendIds([]);
    return StreamProvider<List<Friend>?>.value(
      initialData: null,
      value: DatabaseService(FirebaseAuth.instance.currentUser?.uid).friend(f),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 25,
              right: 25,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color.fromARGB(255, 3, 155, 229),
                //     Color.fromARGB(255, 148, 219, 254)
                //   ],
                // ),
                color: ThemeColors.primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    left: 10,
                    right: 10,
                  ),
                  child: const Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    left: 10,
                    right: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: ThemeColors.secondaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: const TextField(
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search In Main Message..",
                      hintStyle: TextStyle(color: ThemeColors.accentColor),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: ThemeColors.accentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: const Text(
              "Friends",
              style: TextStyle(
                color: ThemeColors.accentColor,
                fontSize: 18,
              ),
            ),
          ),
          const Expanded(
            child: ChatList(),
          ), // const SizedBox(height: 40),
        ],
      ),
    );
  }
}
