import 'package:flutter/material.dart';
import 'package:wagwan/widgets/image_display.dart';
import 'package:wagwan/widgets/theme_colors.dart';

class ImageMessage extends StatelessWidget {
  final bool isLeft;
  final String imgUrl;
  final String time;
  const ImageMessage(
      {super.key,
      required this.isLeft,
      required this.imgUrl,
      required this.time});

  @override
  Widget build(BuildContext context) {
    final image = Image.network(imgUrl);
    return Column(
      crossAxisAlignment:
          isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        InkWell(
          child: Container(
            margin: EdgeInsets.only(
              left: isLeft ? 10 : 100,
              right: isLeft ? 100 : 10,
              bottom: 10,
              top: 10,
            ),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: ThemeColors.accentColor,
                image: DecorationImage(image: image.image, fit: BoxFit.cover)),
            width: 250,
            height: 400,
          ),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                barrierColor: Colors.black,
                pageBuilder: (BuildContext context, _, __) {
                  return ImageDisplay(
                    image: image,
                  );
                },
              ),
            );
          },
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
    );
  }
}
