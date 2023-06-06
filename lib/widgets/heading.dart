import 'package:flutter/material.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class Heading extends StatelessWidget {
  final String text;
  const Heading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ThemeColors.accentColor,
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
