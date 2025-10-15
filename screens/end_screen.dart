import 'package:flutter/material.dart';

class EndScreen extends StatelessWidget {
  final int score;
  final int level;
  final void Function() onRestart;
  const EndScreen({
    super.key,
    required this.score,
    required this.level,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Điểm số: ${score.toString().padLeft(5, '0')}',
            style: const TextStyle(fontSize: 24, color: Colors.amber),
          ),
          const SizedBox(height: 12),
          Text(
            'Level đạt được: $level',
            style: const TextStyle(fontSize: 20, color: Colors.cyan),
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: onRestart, child: const Text('Chơi lại')),
        ],
      ),
    );
  }
}
