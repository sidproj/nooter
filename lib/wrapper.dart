import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wagwan/views/auth/login_view.dart';
import 'package:provider/provider.dart';
import 'package:wagwan/views/content/main_view.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        FirebaseAuth.instance.authStateChanges().listen(
          (user) {
            setUserState(user);
            if (user == null) {
              print('User is currently signed out!');
            } else {
              print('User is signed in!');
            }
          },
        );
      },
    );
  }

  void setUserState(User? user) {
    print("State Changed");
    setState(() {
      this.user = user;
      // prefs.setString("uid", user.uid);
    });
  }

  void setUserStateNull() {
    setState(() {
      user = null;
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: FirebaseAuth.instance.authStateChanges(),
        ),
      ],
      // child: const RegisterView()
      child: (user == null) ? const LoginView() : const MainView(),
    );
  }
}
