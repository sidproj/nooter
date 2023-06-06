import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wagwan/services/authorization.dart';
import 'package:wagwan/services/database.dart';
import 'package:wagwan/widgets/heading.dart';
import 'package:wagwan/widgets/textfield.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email, _pass, _confPass, _fname, _lname;
  String error = "";
  int step = 0;
  @override
  void initState() {
    super.initState();
    _pass = TextEditingController();
    _email = TextEditingController();
    _confPass = TextEditingController();
    _fname = TextEditingController();
    _lname = TextEditingController();
  }

  Widget displayTextFileds() {
    if (step == 0) {
      return Column(
        children: [
          InputField(
            controller: _email,
            isPassword: false,
            hint: "Email",
            suggestions: true,
            isEmail: true,
          ),
          const SizedBox(
            height: 20,
          ),
          InputField(
            controller: _pass,
            isPassword: true,
            hint: "Password",
            suggestions: true,
            isEmail: false,
          ),
          const SizedBox(
            height: 20,
          ),
          InputField(
            controller: _confPass,
            isPassword: true,
            hint: "Confirm Password",
            suggestions: true,
            isEmail: false,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            error,
            style: const TextStyle(
              color: ThemeColors.accentColor2,
              fontSize: 18,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          InputField(
            controller: _fname,
            isPassword: false,
            hint: "First name",
            suggestions: true,
            isEmail: false,
          ),
          const SizedBox(
            height: 20,
          ),
          InputField(
            controller: _lname,
            isPassword: false,
            hint: "Last name",
            suggestions: true,
            isEmail: false,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            error,
            style: const TextStyle(
              color: ThemeColors.accentColor2,
              fontSize: 18,
            ),
          ),
        ],
      );
    }
  }

  Widget displayButtons() {
    if (step == 0) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: const BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    nextStep();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            },
            child: RichText(
              text: const TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: ThemeColors.accentColor, fontSize: 15),
                children: [
                  TextSpan(
                    text: "Login Now!",
                    style: TextStyle(
                      color: ThemeColors.accentColor2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: const BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      step = 0;
                    });
                  },
                  child: const Text(
                    "Previous",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                decoration: const BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    register();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: ThemeColors.accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  void nextStep() {
    if (_email.text.isEmpty) {
      setState(() {
        error = "Please enter email!";
      });
      return;
    }

    if (_pass.text.isEmpty) {
      setState(() {
        error = "Please enter password!";
      });
      return;
    }

    if (_confPass.text.isEmpty) {
      setState(() {
        error = "Please confirm your password!";
      });
      return;
    }

    if (_confPass.text != _pass.text) {
      setState(() {
        error = "Password do not match!";
      });
      return;
    }
    error = "";
    setState(() {
      step = 1;
    });
  }

  void register() async {
    if (_fname.text.isEmpty) {
      setState(() {
        error = "Please enter first name!";
      });
      return;
    }

    if (_lname.text.isEmpty) {
      setState(() {
        error = "Please enter last name!";
      });
      return;
    }

    setState(() {
      error = "";
    });

    print("Here");
    final authorization = Authorization();

    final result = await authorization.register(_email.text, _pass.text);
    print(result);
    if (result['error'] != null) {
      setState(() {
        error = result['error'];
      });
      return;
    }
    final db = DatabaseService(FirebaseAuth.instance.currentUser?.uid);
    db.addUserProfile(_fname.text, _lname.text);
    Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.secondaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Heading(text: "Register"),
              displayTextFileds(),
              displayButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
