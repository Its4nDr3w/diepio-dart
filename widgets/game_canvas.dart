import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import '../game/game.dart';
import '../painters/background_painter.dart';
import '../painters/game_painter.dart';
import 'heart_bar.dart';
import 'exp_bar.dart';
import 'admin_panel.dart';

class GameCanvas extends StatefulWidget {
  final void Function(int score, int level) onEnd;
  final String playerName;
  final Color tankColor;
  GameCanvas({
    Key? key,
    required this.onEnd,
    required this.playerName,
    required this.tankColor,
  }) : super(key: key);

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas>
    with SingleTickerProviderStateMixin {
  bool devMode = false;
  late Game game;
  late Ticker _ticker;
  Size screenSize = const Size(800, 600);
  bool autoFire = true;

  @override
  void initState() {
    super.initState();
    game = Game(screenSize.width, screenSize.height);
    game.tank.playerName = widget.playerName;
    game.tank.color = widget.tankColor;
    _ticker = createTicker((_) {
      setState(() {
        game.update();
        // Nếu máu tank < 1 thì gọi callback onEnd và tạo lại game mới
        if (game.tank.health < 1) {
          widget.onEnd(game.score, game.tank.level);
          // Reset lại game mới
          game = Game(screenSize.width, screenSize.height);
          game.tank.playerName = widget.playerName;
          game.tank.color = widget.tankColor;
        }
      });
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    // Tính camOffset một lần duy nhất cho cả background và game painter
    final t = game.tank;
    final camOffset = Offset(
      screenSize.width / 2 - t.x,
      screenSize.height / 2 - t.y,
    );
    final double cameraScale = autoFire ? 0.85 : 1.0;
    return Stack(
      children: [
        // Hiển thị điểm ở góc trên bên phải màn hình
        Positioned(
          top: 16,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              game.score.toString().padLeft(5, '0'),
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 2,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ),
        // Hiển thị gốc tọa độ và tốc độ tank (km/h) trên đầu tank khi devMode bật
        if (devMode) ...[
          Positioned(
            left: game.tank.x + camOffset.dx - 40,
            top: game.tank.y + camOffset.dy - game.tank.size - 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Speed: ${(sqrt(game.tank.vx * game.tank.vx + game.tank.vy * game.tank.vy) * 20).toStringAsFixed(1)} km/h',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tank: (${game.tank.x.toStringAsFixed(1)}, ${game.tank.y.toStringAsFixed(1)})',
                    style: const TextStyle(color: Colors.cyan, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Hiển thị tọa độ các shape
          for (final s in game.shapes)
            Positioned(
              left: s.x + camOffset.dx - 30,
              top: s.y + camOffset.dy - s.size - 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '(${s.x.toStringAsFixed(1)}, ${s.y.toStringAsFixed(1)})',
                  style: const TextStyle(color: Colors.orange, fontSize: 11),
                ),
              ),
            ),
        ],
        AnimatedScale(
          scale: cameraScale,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Stack(
            children: [
              CustomPaint(
                size: screenSize,
                painter: BackgroundPainter(screenSize, camOffset),
              ),
              CustomPaint(
                size: screenSize,
                painter: GamePainter(game, camOffset),
              ),
            ],
          ),
        ),
        // Joystick trái: move
        Positioned(
          left: 20,
          bottom: 20,
          child: _buildJoystick((dx, dy, r) {
            game.moveInput.update(dx, dy, r);
          }),
        ),
        // Nút bật/tắt tự động bắn
        Positioned(
          top: 20,
          left: 20,
          child: ElevatedButton(
            onPressed: () => setState(() {
              autoFire = !autoFire;
              game.autoFire = autoFire;
            }),
            child: Text(autoFire ? "Auto Fire: ON" : "Auto Fire: OFF"),
          ),
        ),
        // Nút chế độ nhà phát triển
        Positioned(
          top: 70,
          left: 20,
          child: ElevatedButton(
            onPressed: () => setState(() {
              devMode = !devMode;
            }),
            child: Text(devMode ? "Developer Mode: ON" : "Developer Mode: OFF"),
          ),
        ),
        // Panel chức năng admin (chỉ hiện khi devMode)
        if (devMode)
          Positioned(top: 120, left: 20, child: AdminPanel(game: game)),
        // Text tên và level phía trên exp bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 60,
          child: Center(
            child: Text(
              '${game.tank.playerName}  |  Level ${game.tank.level}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ),
        // Thanh exp phía trên thanh máu
        Positioned(
          left: 0,
          right: 0,
          bottom: 36,
          child: ExpBar(exp: game.tank.exp, maxExp: game.tank.maxExp),
        ),
        // Thanh máu tank dưới cùng màn hình
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: HeartBar(
            health: game.tank.health,
            maxHealth: game.tank.maxHealth,
          ),
        ),
      ],
    );
  }

  Widget _buildJoystick(void Function(double, double, double) onMove) {
    double radius = 50;
    ValueNotifier<Offset> pos = ValueNotifier(Offset.zero);

    return GestureDetector(
      onPanUpdate: (d) {
        Offset delta = d.localPosition - Offset(radius, radius);
        if (delta.distance > radius) {
          delta = Offset.fromDirection(delta.direction, radius);
        }
        pos.value = delta;
        onMove(delta.dx, delta.dy, radius);
      },
      onPanEnd: (_) {
        pos.value = Offset.zero;
        onMove(0, 0, radius);
      },
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: ValueListenableBuilder<Offset>(
          valueListenable: pos,
          builder: (_, value, __) {
            return Center(
              child: Transform.translate(
                offset: value,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
