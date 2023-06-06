import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/models/user.dart';
import 'package:wagwan/views/content/profile_view.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class NewSettingsView extends StatelessWidget {
  const NewSettingsView({
    super.key,
  });

  Widget renderAvatar(final profile) {
    if (profile != null) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          image: DecorationImage(
              image: Image.network(profile ?? "").image, fit: BoxFit.cover),
        ),
      );
    }
    return const Icon(
      Icons.person,
      size: 60,
      color: ThemeColors.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);

    return Column(
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
                ),
                child: const Text(
                  "Settings",
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewProfileView(user: user),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: ThemeColors.accentColor,
                      child: renderAvatar(user?.profile),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user?.fname} ${user?.lname}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${user?.description}',
                          style: const TextStyle(
                            color: ThemeColors.accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/login", (route) => false);
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 25,
              bottom: 25,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.logout,
                  size: 30,
                  color: ThemeColors.accentColor,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: ThemeColors.accentColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
