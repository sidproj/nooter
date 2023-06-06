import 'package:flutter/material.dart';
import 'package:wagwan/services/authorization.dart';
import 'package:wagwan/widgets/theme_colors.dart';

import '../../widgets/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  String error = "";

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  void login() async {
    if (_email.text.isEmpty) {
      setState(() {
        error = "Please enter email!";
      });
      return;
    }

    if (_password.text.isEmpty) {
      setState(() {
        error = "Please enter password!";
      });
      return;
    }
    setState(() {
      error = "";
    });
    final authorization = Authorization();
    final result = await authorization.login(_email.text, _password.text);
    if (result['error'] != null) {
      setState(() {
        error = result['error'];
      });
      return;
    }
    print(result);
    Navigator.of(context).pushNamedAndRemoveUntil("/main", (route) => false);
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
              const Text(
                "Login",
                style: TextStyle(
                  color: ThemeColors.accentColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Column(
                children: [
                  InputField(
                    controller: _email,
                    isPassword: false,
                    hint: "Email",
                    suggestions: false,
                    isEmail: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _password,
                    isPassword: true,
                    hint: "Password",
                    suggestions: false,
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
                  const SizedBox(
                    height: 10,
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
                        login();
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
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/register", (route) => false);
                    },
                    child: RichText(
                      text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                              color: ThemeColors.accentColor, fontSize: 15),
                          children: [
                            TextSpan(
                              text: "Create Now!",
                              style: TextStyle(
                                color: ThemeColors.accentColor2,
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
