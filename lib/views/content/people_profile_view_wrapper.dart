import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/views/content/people_profile_view.dart';

import '../../models/firendids.dart';
import '../../services/database.dart';

class PeopleProfileViewWrapper extends StatefulWidget {
  final String uid;
  final String? profile;
  final String displayName;
  final String description;
  const PeopleProfileViewWrapper(
      {super.key,
      required this.uid,
      this.profile,
      required this.displayName,
      required this.description});

  @override
  State<PeopleProfileViewWrapper> createState() =>
      _PeopleProfileViewWrapperState();
}

class _PeopleProfileViewWrapperState extends State<PeopleProfileViewWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FriendIds>.value(
          initialData: FriendIds([]),
          value: DatabaseService(FirebaseAuth.instance.currentUser?.uid)
              .friendsIds(widget.uid),
        ),
      ],
      child: PeopleProfileView(
        uid: widget.uid,
        profile: widget.profile,
        description: widget.description,
        displayName: widget.displayName,
      ),
    );
  }
}
