import 'package:flutter/material.dart';
import '../game/game.dart';

class AdminPanel extends StatelessWidget {
  final Game game;
  const AdminPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            game.tank.health += 100;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tăng máu +100'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Tăng máu'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            game.tank.levelSystem.addExp(500);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tăng exp +500'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: const Text('Tăng exp'),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                game.tank.speed += 0.2;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tăng tốc độ: ${game.tank.speed.toStringAsFixed(2)}',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Tăng tốc độ'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (game.tank.speed > 0.2) {
                  game.tank.speed -= 0.2;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Giảm tốc độ: ${game.tank.speed.toStringAsFixed(2)}',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Giảm tốc độ'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                final msg = game.tank.addBarrel();
                if (msg != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Thêm barrel'),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: () {
                final msg = game.tank.removeBarrel();
                if (msg != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: const Text('Xóa barrel'),
            ),
          ],
        ),
      ],
    );
  }
}
