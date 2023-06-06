import 'package:flutter/material.dart';

class ImageDisplay extends StatefulWidget {
  final Image image;
  const ImageDisplay({super.key, required this.image});

  @override
  State<ImageDisplay> createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  bool _visible = false;

  void handleFadeIn() {
    setState(() {
      _visible = true;
    });
  }

  void handeFadeOut() {
    setState(() {
      _visible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleFadeIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () {
          handeFadeOut();
          Navigator.of(context).pop();
        },
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Image(
            image: widget.image.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
