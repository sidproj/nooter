import 'package:flutter/material.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class Message extends StatelessWidget {
  final bool isLeft;
  final String message;
  final String time;
  const Message(
      {super.key,
      required this.isLeft,
      required this.message,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 25,
              right: 25,
            ),
            decoration: BoxDecoration(
              color:
                  isLeft ? ThemeColors.accentColor : ThemeColors.secondaryColor,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(20),
                bottomLeft: const Radius.circular(20),
                topLeft: isLeft
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
                bottomRight: isLeft
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isLeft ? 10 : 0,
              right: isLeft ? 0 : 10,
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
