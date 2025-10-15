import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Tank Game',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}
