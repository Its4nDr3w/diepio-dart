// lib/game/game.dart
import 'dart:math';
import 'package:flutter/material.dart';

import 'entities/tank.dart';
import 'entities/bullet.dart';
import 'entities/shape.dart';
import 'core/input.dart';

class Game {
  /// Tank của người chơi
  final Tank tank;

  /// Danh sách đạn đang tồn tại trên màn hình
  final List<Bullet> bullets = [];

  /// Danh sách các shape (quái) trên màn hình
  final List<Shape> shapes = [];

  /// Bộ đếm thời gian spawn shape
  int spawnTimer = 60;

  /// Số lượng shape tối đa trên màn hình
  static const int maxShapes = 20;

  /// Kích thước màn hình game
  final double width;
  final double height;

  /// Input điều khiển di chuyển tank
  final JoystickInput moveInput = JoystickInput();

  /// Kích thước màn hình hiện tại
  Size screenSize = const Size(1920, 1080);

  /// Chế độ tự động bắn
  bool autoFire = true;

  /// Điểm số hiện tại
  int score = 0;

  // Thời gian frame cuối cùng tank bị sát thương
  int lastDamageFrame = 0;
  // Frame hiện tại
  int frameCount = 0;

  Game(double w, double h)
    : width = w,
      height = h,
      tank = Tank(x: w / 2, y: h / 2) {
    screenSize = Size(w, h);
  }

  void resize(double w, double h) => screenSize = Size(w, h);

  void update() {
    frameCount++;
    // Di chuyển tank theo input joystick, giới hạn trong màn hình
    tank.move(moveInput.dx, moveInput.dy, screenSize);

    // Xoay hướng tank theo joystick nếu đang di chuyển
    if (moveInput.magnitude > 0.2) tank.rotateTo(moveInput.angle);

    // Nếu autoFire bật, tank sẽ tự động bắn
    if (autoFire) bullets.addAll(tank.fire());

    // Cập nhật trạng thái đạn
    for (var b in bullets) b.update();
    // Cập nhật trạng thái shape (xoay, di chuyển)
    for (var s in shapes) s.update();

    // Spawn shape quanh tank, tránh overlap, tuỳ chế độ autoFire
    int spawnInterval = autoFire ? 60 : 120; // thời gian giữa các lần spawn
    double spawnRadius = autoFire ? 500 : 350; // bán kính spawn
    int spawnTries = autoFire ? 50 : 30; // số lần thử spawn
    int spawnBatch = autoFire ? 2 : 1; // số lượng spawn mỗi lần
    if (spawnTimer > 0) {
      spawnTimer--;
    } else if (shapes.length < maxShapes) {
      spawnTimer = spawnInterval;
      final rand = Random();
      int spawned = 0;
      int tries = 0;
      while (spawned < spawnBatch &&
          tries < spawnTries &&
          shapes.length < maxShapes) {
        tries++;
        // Tính vị trí spawn ngẫu nhiên quanh tank
        final angle = rand.nextDouble() * 2 * 3.1415926535;
        final r = spawnRadius * (0.7 + 0.3 * rand.nextDouble());
        final candidateX = tank.x + r * cos(angle);
        final candidateY = tank.y + r * sin(angle);
        final newShape = Shape.random(candidateX, candidateY);
        // Kiểm tra overlap với các shape khác
        bool overlap = false;
        for (final s in shapes) {
          final dx = s.x - newShape.x;
          final dy = s.y - newShape.y;
          final dist2 = dx * dx + dy * dy;
          final minDist = s.size + newShape.size + 8;
          if (dist2 < minDist * minDist) {
            overlap = true;
            break;
          }
        }
        // Nếu không overlap thì thêm vào danh sách
        if (!overlap) {
          shapes.add(newShape);
          spawned++;
        }
      }
    }

    // Xử lý va chạm giữa đạn và shape (vật lý đẩy lùi)
    for (int i = bullets.length - 1; i >= 0; i--) {
      final b = bullets[i];
      for (int j = shapes.length - 1; j >= 0; j--) {
        final s = shapes[j];
        final dx = s.x - b.x;
        final dy = s.y - b.y;
        final dist2 = dx * dx + dy * dy;
        final collideDist = (s.radius + b.size);
        if (dist2 < collideDist * collideDist) {
          s.health -= 50;
          b.lifetime = 0;
          // Đẩy lùi shape khi bị bắn
          final dist = sqrt(dist2) + 0.01;
          final nx = dx / dist;
          final ny = dy / dist;
          s.vx += nx * 2.0 / s.mass;
          s.vy += ny * 2.0 / s.mass;
          // Nếu shape chết thì cộng exp cho tank và điểm
          if (s.health - 10 <= 0) {
            tank.levelSystem.addExp(s.expReward);
            score += s.score;
          }
          break;
        }
      }
    }

    // Xử lý va chạm giữa tank và shape (cả hai cùng mất máu)
    for (final s in shapes) {
      final dx = s.x - tank.x;
      final dy = s.y - tank.y;
      final dist2 = dx * dx + dy * dy;
      final minDist = s.radius + tank.radius;
      if (dist2 < minDist * minDist) {
        final dist = sqrt(dist2) + 0.01;
        final nx = dx / dist;
        final ny = dy / dist;
        // Đẩy lùi cả hai
        final overlap = minDist - dist;
        s.x += nx * overlap * (tank.mass / (tank.mass + s.mass));
        s.y += ny * overlap * (tank.mass / (tank.mass + s.mass));
        tank.x -= nx * overlap * (s.mass / (tank.mass + s.mass));
        tank.y -= ny * overlap * (s.mass / (tank.mass + s.mass));
        // Phản lực
        s.vx += nx * 1.5 / s.mass;
        s.vy += ny * 1.5 / s.mass;
        tank.vx -= nx * 1.5 / tank.mass;
        tank.vy -= ny * 1.5 / tank.mass;
        // Sát thương lên tank: phụ thuộc kích thước shape
        final tankDamage = 0.2 + s.size * 0.05;
        tank.health -= tankDamage;
        lastDamageFrame = frameCount; // cập nhật frame bị sát thương
        // Sát thương lên shape: cố định
        s.health -= 10;
        // Nếu shape chết thì cộng exp và điểm
        if (s.health <= 0) {
          tank.levelSystem.addExp(s.expReward);
          score += s.score;
        }
      }
    }

    // Xử lý va chạm giữa các shape với nhau (không đè lên nhau, vật lý bật lùi)
    for (int i = 0; i < shapes.length; i++) {
      for (int j = i + 1; j < shapes.length; j++) {
        final a = shapes[i];
        final b = shapes[j];
        final dx = b.x - a.x;
        final dy = b.y - a.y;
        final dist2 = dx * dx + dy * dy;
        final minDist = a.radius + b.radius;
        if (dist2 < minDist * minDist) {
          final dist = sqrt(dist2) + 0.01;
          final nx = dx / dist;
          final ny = dy / dist;
          final overlap = minDist - dist;
          // Đẩy lùi hai shape ra xa nhau
          a.x -= nx * overlap * (b.mass / (a.mass + b.mass));
          a.y -= ny * overlap * (b.mass / (a.mass + b.mass));
          b.x += nx * overlap * (a.mass / (a.mass + b.mass));
          b.y += ny * overlap * (a.mass / (a.mass + b.mass));
          // Phản lực
          a.vx -= nx * 0.5 / a.mass;
          a.vy -= ny * 0.5 / a.mass;
          b.vx += nx * 0.5 / b.mass;
          b.vy += ny * 0.5 / b.mass;
        }
      }
    }

    // Cập nhật vật lý cho shape (ma sát)
    for (final s in shapes) {
      s.update();
      // Ma sát
      s.vx *= 0.95;
      s.vy *= 0.95;
    }

    // Tự hồi máu nếu đủ điều kiện
    if (frameCount - lastDamageFrame > 420 && tank.health < tank.maxHealth) {
      // 5s không nhận sát thương
      if ((frameCount - lastDamageFrame) % 60 == 0) {
        // mỗi giây
        tank.health = (tank.health + 1).clamp(0, tank.maxHealth);
      }
    }

    // cleanup
    shapes.removeWhere((s) => s.isDead);
    bullets.removeWhere((b) => b.isDead);
  }
}
