import 'package:flutter/material.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final bool isEmail;
  final String hint;
  final bool suggestions;
  const InputField(
      {super.key,
      required this.controller,
      required this.isPassword,
      required this.hint,
      required this.suggestions,
      required this.isEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
        color: ThemeColors.accentColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        obscureText: isPassword,
        enableSuggestions: suggestions,
        autocorrect: false,
        keyboardType: isEmail ? TextInputType.emailAddress : null,
        controller: controller,
        style: const TextStyle(
            color: ThemeColors.secondaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w500),
        cursorColor: ThemeColors.secondaryColor,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: ThemeColors.secondaryColor,
            fontSize: 20,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
