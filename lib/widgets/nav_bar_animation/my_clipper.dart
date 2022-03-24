import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Rect> {
  MyClipper({
    required this.width,
    required this.height,
    required this.left,
  });
  final double width;
  final double height;
  final double left;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(left, 0, width, height);

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
