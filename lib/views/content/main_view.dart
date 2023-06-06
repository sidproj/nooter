import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/firendids.dart';
import 'package:wagwan/models/requested_ids.dart';
import 'package:wagwan/models/user.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/views/content/chat_view_wrapper.dart';
import 'package:wagwan/views/content/settings_view.dart';
import 'package:wagwan/views/content/people_view.dart';
import 'package:wagwan/widgets/theme_colors.dart';

import '../../background/back_service.dart';
import '../../models/request_ids.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  Widget handleNavigation() {
    if (_selectedIndex == 0) return const ChatViewWrapper();
    if (_selectedIndex == 2) return const NewSettingsView();
    return const PeopleView();
  }

  void initBackgroundService() async {
    await initBgService();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initBackgroundService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //list of ids of friends
        StreamProvider<FriendIds?>.value(
          initialData: null,
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .friendsIds(
            (FirebaseAuth.instance.currentUser?.uid ?? ""),
          ),
        ),

        //list of ids of people who have requested
        StreamProvider<RequestedIds?>.value(
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .requestedIds(),
          initialData: null,
        ),

        // list of ids of requests
        StreamProvider<RequestIds?>.value(
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .requestIds(),
          initialData: null,
        ),

        //user data
        StreamProvider<UserModel?>.value(
            value: DatabaseService(FirebaseAuth.instance.currentUser?.uid).user,
            initialData: null),
      ],
      child: Scaffold(
        backgroundColor: ThemeColors.secondaryColor,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ThemeColors.secondaryColor,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: ThemeColors.accentColor,
          selectedItemColor: ThemeColors.accentColor,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                (_selectedIndex == 0)
                    ? Icons.messenger
                    : Icons.messenger_outline,
                size: 30,
              ),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                (_selectedIndex == 1)
                    ? Icons.person
                    : Icons.person_outline_sharp,
                size: 30,
              ),
              label: "People",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                (_selectedIndex == 2)
                    ? Icons.settings
                    : Icons.settings_outlined,
                size: 30,
              ),
              label: "Settings",
            ),
          ],
        ),
        body: handleNavigation(),
      ),
    );
  }
}
