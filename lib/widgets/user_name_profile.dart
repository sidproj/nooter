import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNameProfile extends StatefulWidget {
  const UserNameProfile({super.key});

  @override
  State<UserNameProfile> createState() => _UserNameProfileState();
}

class _UserNameProfileState extends State<UserNameProfile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<DocumentSnapshot?>(context);
    String fullname = "";
    if (user != null) fullname = user['first_name'] + " " + user['last_name'];
    return Row(
      children: [
        const Icon(
          Icons.person_2,
          size: 39,
          color: Colors.white,
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name",
              style: TextStyle(
                color: Colors.lightBlue[500],
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              fullname,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "This is not your username.",
              style: TextStyle(
                color: Color.fromARGB(255, 187, 187, 187),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
