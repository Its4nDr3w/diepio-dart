import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const StartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Bắt đầu chơi'),
    );
  }
}
