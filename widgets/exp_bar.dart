import 'package:flutter/material.dart';

class ExpBar extends StatelessWidget {
  final double exp;
  final double maxExp;
  const ExpBar({super.key, required this.exp, required this.maxExp});

  @override
  Widget build(BuildContext context) {
    final percent = (exp / maxExp).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 0),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
          ),
          FractionallySizedBox(
            widthFactor: percent,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
