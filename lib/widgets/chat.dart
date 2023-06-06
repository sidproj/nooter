import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/views/content/message_view.dart';
import 'package:wagwan/views/content/people_profile_view_wrapper.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class Chat extends StatefulWidget {
  final int type;
  final String display;
  final String subDisplay;
  final String uid;
  final String? profile;
  final String description;
  const Chat({
    super.key,
    required this.type,
    required this.display,
    required this.subDisplay,
    required this.uid,
    this.profile,
    required this.description,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // 0 for new people
  // 1 for friends
  // 2 for requests
  // 3 for requested
  // 4 for blocked
  // 5 for friend in chat
  Widget handleType() {
    // non friend
    if (widget.type == 0) {
      return ElevatedButton(
        onPressed: () {
          DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .sendFriendRequest(widget.uid);
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            ThemeColors.primaryColor,
          ),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
        ),
        child: const Text("Add"),
      );
    }
    //request
    if (widget.type == 2) {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              DatabaseService(FirebaseAuth.instance.currentUser?.uid)
                  .acceptFriendRequest(widget.uid);
            },
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(
                ThemeColors.primaryColor,
              ),
              foregroundColor: MaterialStatePropertyAll(
                ThemeColors.accentColor,
              ),
            ),
            icon: const Icon(Icons.check),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {
              DatabaseService(FirebaseAuth.instance.currentUser?.uid)
                  .removeRequest(widget.uid);
            },
            style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(
                ThemeColors.primaryColor,
              ),
              foregroundColor: MaterialStatePropertyAll(
                ThemeColors.accentColor,
              ),
            ),
            icon: const Icon(Icons.delete_outlined),
          )
        ],
      );
    }

    // friend
    if (widget.type == 1) {
      return ElevatedButton(
        onPressed: () {
          DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .removeFriend(widget.uid);
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            ThemeColors.primaryColor,
          ),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
        ),
        child: const Text("Remove"),
      );
    }

    if (widget.type == 3) {
      return ElevatedButton(
        onPressed: () {
          DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .removeRequested(widget.uid);
        },
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            ThemeColors.accentColor,
          ),
          foregroundColor: MaterialStatePropertyAll(ThemeColors.primaryColor),
        ),
        child: const Text("Requested"),
      );
    }
    //blocked
    if (widget.type == 4) {
      return ElevatedButton(
        onPressed: () {},
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Color.fromARGB(255, 3, 155, 229),
          ),
          foregroundColor: MaterialStatePropertyAll(Colors.white),
        ),
        child: const Text("Unblock"),
      );
    }
    //friend in chat
    if (widget.type == 5) {
      return const Text(
        "Time",
        style: TextStyle(
          color: ThemeColors.accentColor2,
        ),
      );
    }
    if (widget.type == 6) {
      //mutual friend
      return const Text(
        "Mutual",
        style: TextStyle(
          color: ThemeColors.accentColor2,
        ),
      );
    }
    return const SizedBox();
  }

  Widget renderAvatar() {
    if (widget.profile != null) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(
              image: Image.network(widget.profile ?? "").image,
              fit: BoxFit.cover),
        ),
      );
    }
    return const Icon(
      Icons.person,
      size: 40,
      color: ThemeColors.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // if friend in chat then open message view
        if (widget.type == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageView(
                display: widget.display,
                subDisplay: widget.subDisplay,
                uid: widget.uid,
                profile: widget.profile,
                discription: widget.description,
              ),
            ),
          );
        }
        if (widget.type == 7) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PeopleProfileViewWrapper(
                uid: widget.uid,
                profile: widget.profile,
                description: widget.description,
                displayName: widget.display,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 20,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: ThemeColors.accentColor,
                  child: renderAvatar(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.display,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.subDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ThemeColors.accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            handleType(),
          ],
        ),
      ),
    );
  }
}
