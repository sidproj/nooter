import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/widgets/textfield.dart';
import 'package:wagwan/widgets/theme_colors.dart';

import '../../models/user.dart';

class NewProfileView extends StatefulWidget {
  final UserModel? user;
  const NewProfileView({super.key, required this.user});

  @override
  State<NewProfileView> createState() => _NewProfileViewState();
}

class _NewProfileViewState extends State<NewProfileView> {
  XFile? image;

  Widget renderAvatar() {
    if (widget.user?.profile != null) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(
              image: Image.network(widget.user?.profile ?? "").image,
              fit: BoxFit.cover),
        ),
      );
    }
    return const Icon(
      Icons.person,
      size: 100,
      color: ThemeColors.primaryColor,
    );
  }

  void handleProfileUpload() {
    File file = File(image?.path ?? "");
    DatabaseService(FirebaseAuth.instance.currentUser?.uid)
        .uploadProfilePic(file);
  }

  void handleImagePick() async {
    ImagePicker picker = ImagePicker();
    final tempImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (tempImage != null) {
      setState(() {
        image = tempImage;
      });
      handleProfileUpload();
    }
  }

  void handleChangeDisplayName(String displayName) {
    if (displayName.replaceAll(" ", '').isEmpty) return;
    DatabaseService(FirebaseAuth.instance.currentUser?.uid)
        .changeDisplayName(displayName);
  }

  void handleDescriptionChange(String description) {
    if (description.replaceAll(" ", '').isEmpty) return;
    DatabaseService(FirebaseAuth.instance.currentUser?.uid)
        .changeDescription(description);
  }

  Future<dynamic> displayEditModal(final context, int type) {
    final TextEditingController _inputController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ThemeColors.secondaryColor,
            elevation: 0,
            title: Text(
              type == 0 ? "Change display name" : "Change description",
              style: const TextStyle(
                  color: ThemeColors.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            content: Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    controller: _inputController,
                    isPassword: false,
                    hint: type == 0 ? "New display name" : "New description",
                    suggestions: true,
                    isEmail: false,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            ThemeColors.primaryColor,
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          print(_inputController.text);
                          type == 0
                              ? handleChangeDisplayName(_inputController.text)
                              : handleDescriptionChange(_inputController.text);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            ThemeColors.primaryColor,
                          ),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        child: const Text("Update"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20),
            decoration: const BoxDecoration(
              color: ThemeColors.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  bottom: 25,
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
                  color: ThemeColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        handleImagePick();
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: ThemeColors.accentColor,
                        child: renderAvatar(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 39,
                              color: ThemeColors.accentColor,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                    color: ThemeColors.accentColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.user?.display_name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "This is not your username.",
                                  style: TextStyle(
                                    color: ThemeColors.accentColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            displayEditModal(context, 0);
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 30,
                            color: ThemeColors.accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 39,
                              color: ThemeColors.accentColor,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "About",
                                  style: TextStyle(
                                    color: ThemeColors.accentColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${widget.user?.description}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            displayEditModal(context, 1);
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 30,
                            color: ThemeColors.accentColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
