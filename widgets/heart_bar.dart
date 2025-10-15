import 'package:flutter/material.dart';

class HeartBar extends StatelessWidget {
  final double health;
  final double maxHealth;
  const HeartBar({super.key, required this.health, required this.maxHealth});

  @override
  Widget build(BuildContext context) {
    final percent = (health / maxHealth).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 12),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
          ),
          FractionallySizedBox(
            widthFactor: percent,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 194, 19),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          //hiện máu trên thanh heart bar
          Positioned.fill(
            child: Center(
              child: Text(
                '${health.toInt()} / ${maxHealth.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
