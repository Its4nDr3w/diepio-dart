import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final Size screenSize;
  final Offset camOffset;
  BackgroundPainter(this.screenSize, this.camOffset);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
