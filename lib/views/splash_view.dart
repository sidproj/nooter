import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wagwan/widgets/theme_colors.dart';
import 'package:wagwan/wrapper.dart';

import '../firebase_options.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future initFireBase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return Future.delayed(const Duration(milliseconds: 2500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primaryColor,
      body: FutureBuilder(
        future: initFireBase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Wrapper();
          }
          return const Center(
            child: Text(
              "Nooter",
              style: TextStyle(
                color: ThemeColors.accentColor,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        },
      ),
    );
  }
}
