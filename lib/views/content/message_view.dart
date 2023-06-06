import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/message.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/views/content/people_profile_view_wrapper.dart';
import 'package:wagwan/widgets/theme_colors.dart';
import 'message_list.dart';

class MessageView extends StatefulWidget {
  final String display;
  final String subDisplay;
  final String uid;
  final String? profile;
  final String discription;
  const MessageView({
    super.key,
    required this.display,
    required this.subDisplay,
    required this.uid,
    required this.profile,
    required this.discription,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _message = TextEditingController();
  XFile? image;

  void handelMessageSend() {
    if (_message.text.replaceAll(" ", '').isEmpty) return;
    DatabaseService(FirebaseAuth.instance.currentUser?.uid)
        .sendMessage(_message.text, widget.uid, null);
    _scrollDown();
    _message.text = "";
  }

  void _scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 200);
  }

  Future handleImageUpload() async {
    File file = File(image?.path ?? "");
    DatabaseService(FirebaseAuth.instance.currentUser?.uid)
        .sendImageViaMessage(file, widget.uid);
  }

  void handleImagePick() async {
    ImagePicker picker = ImagePicker();
    final tempImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (tempImage != null) {
      setState(() {
        image = tempImage;
      });
      handleImageUpload();
    }
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
      size: 25,
      color: ThemeColors.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<MessageModel>>.value(
          initialData: const [],
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .getMessages(widget.uid),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 75,
          backgroundColor: ThemeColors.primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
            ),
            color: ThemeColors.accentColor,
          ),
          title: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PeopleProfileViewWrapper(
                    uid: widget.uid,
                    profile: widget.profile,
                    description: widget.discription,
                    displayName: widget.display,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.subDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ThemeColors.accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(),
          decoration: const BoxDecoration(
            color: ThemeColors.primaryColor,
          ),
          child: Column(
            children: [
              // const Divider(
              //   color: Color.fromARGB(62, 158, 158, 158),
              // ),
              Expanded(
                child: MessageList(
                  scrollController: scrollController,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: ThemeColors.secondaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        size: 30,
                        color: ThemeColors.accentColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: ThemeColors.accentColor,
                          ),
                        ),
                        controller: _message,
                        style: const TextStyle(
                          color: ThemeColors.accentColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        handleImagePick();
                      },
                      icon: const Icon(
                        Icons.image,
                        size: 35,
                        color: ThemeColors.accentColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        handelMessageSend();
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 30,
                        color: ThemeColors.accentColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
