import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/views/content/connection_list.dart';

import '../../models/firendids.dart';
import '../../models/friend.dart';
import '../../services/database.dart';
import '../../widgets/theme_colors.dart';

class PeopleProfileView extends StatefulWidget {
  final String uid;
  final String? profile;
  final String displayName;
  final String description;
  const PeopleProfileView(
      {super.key,
      required this.uid,
      this.profile,
      required this.displayName,
      required this.description});

  @override
  State<PeopleProfileView> createState() => _PeopleProfileViewState();
}

class _PeopleProfileViewState extends State<PeopleProfileView> {
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
      size: 100,
      color: ThemeColors.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    FriendIds f = Provider.of<FriendIds>(context);
    print(f.uids);
    return StreamProvider<List<Friend>?>.value(
      initialData: null,
      value: DatabaseService(FirebaseAuth.instance.currentUser?.uid).friend(f),
      child: Scaffold(
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
                    color: ThemeColors.primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
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
                                    widget.displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                    widget.description,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
              color: ThemeColors.accentColor,
            ),
            const Expanded(
              child: ConnectionList(),
            )
          ],
        ),
        // ),
      ),
    );
  }
}
