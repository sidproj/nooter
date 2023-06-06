import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/newPeople.dart';
import 'package:wagwan/models/request_ids.dart';
import 'package:wagwan/models/requested.dart';
import 'package:wagwan/models/requested_ids.dart';
import 'package:wagwan/views/content/friend_list.dart';
import 'package:wagwan/views/content/non_friend_list.dart';
import 'package:wagwan/views/content/requested_list.dart';
import 'package:wagwan/views/content/requests_list.dart';
import 'package:wagwan/widgets/theme_colors.dart';

import '../../models/firendids.dart';
import '../../models/friend.dart';
import '../../models/requests.dart';
import '../../services/database.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({super.key});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  int view = 0;

  // 0 for new people
  // 1 for friends
  // 2 for requests
  // 3 for requested
  Widget handleView() {
    // 0 for new people
    if (view == 0) {
      return const NonFriendList();
    }

    // 1 for friends
    if (view == 1) {
      return const FriendList();
    }

    // 2 for requests
    if (view == 2) {
      return const RequestList();
    }

    //requesteds
    return const RequestedList();
  }

  @override
  Widget build(BuildContext context) {
    FriendIds f = Provider.of<FriendIds?>(context) ?? FriendIds([]);

    RequestedIds reqIds =
        Provider.of<RequestedIds?>(context) ?? RequestedIds([]);

    RequestIds requestIds = Provider.of<RequestIds?>(context) ?? RequestIds([]);

    return MultiProvider(
      providers: [
        //stream of list of friends
        StreamProvider<List<Friend>?>.value(
          initialData: null,
          value:
              DatabaseService(FirebaseAuth.instance.currentUser?.uid).friend(f),
        ),

        //stream of list of non friends
        StreamProvider<List<NonFriend>?>.value(
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .nonFriend(f),
          initialData: null,
        ),

        //stream of list of requesteds
        StreamProvider<List<Requested>?>.value(
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .requesteds(reqIds),
          initialData: null,
        ),

        //stream of list of requests
        StreamProvider<List<Requests>?>.value(
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .requests(requestIds),
          initialData: null,
        ),
      ],
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
                    "People",
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
                      hintText: "Search people..",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    view = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: view == 0
                        ? const Border(
                            bottom: BorderSide(
                              width: 2,
                              color: ThemeColors.accentColor,
                            ),
                          )
                        : const Border(),
                  ),
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: const Text(
                    "New",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    view = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    border: view == 1
                        ? const Border(
                            bottom: BorderSide(
                              width: 2,
                              color: ThemeColors.accentColor,
                            ),
                          )
                        : const Border(),
                  ),
                  child: const Text(
                    "Friends",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    view = 2;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: view == 2
                        ? const Border(
                            bottom: BorderSide(
                              width: 2,
                              color: ThemeColors.accentColor,
                            ),
                          )
                        : const Border(),
                  ),
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: const Text(
                    "Requests",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    view = 3;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: view == 3
                        ? const Border(
                            bottom: BorderSide(
                              width: 2,
                              color: ThemeColors.accentColor,
                            ),
                          )
                        : const Border(),
                  ),
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: const Text(
                    "Requested",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: handleView(),
          ), // const SizedBox(height: 40),
        ],
      ),
    );
  }
}
