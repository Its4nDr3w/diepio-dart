import 'dart:math';
import 'package:flutter/material.dart';

import '../core/settings.dart';
import 'barrel.dart';
import 'bullet.dart';
import 'entity.dart';
import '../core/level_system.dart';

class Tank extends Entity {
  double speed = 1.0;
  double angle = 0;
  double alpha = 1.0;
  Color color;
  final List<Barrel> barrels = [];
  double health;
  double maxHealth;
  final LevelSystem levelSystem = LevelSystem();
  String playerName = "Player";

  double get exp => levelSystem.exp;
  double get maxExp => levelSystem.expToNext;
  int get level => levelSystem.level;
  double get size => radius;

  Tank({
    required double x,
    required double y,
    double size = GameSettings.tankSize,
    this.color = GameSettings.tankColor,
    this.health = 100,
    this.maxHealth = 100,
  }) : super(x: x, y: y, vx: 0, vy: 0, radius: size, mass: 2.0) {
    barrels.add(Barrel());
  }

  // di chuyển và giữ tank trong màn hình
  void move(double dx, double dy, Size screenSize) {
    vx += dx * 0.5 * speed;
    vy += dy * 0.5 * speed;
    // Giới hạn tốc độ
    vx = vx.clamp(-5, 5);
    vy = vy.clamp(-5, 5);
    // Cập nhật vị trí
    super.update();
    // Ma sát
    vx *= 0.9;
    vy *= 0.9;
    // Hiệu ứng giật nòng
    for (var b in barrels) {
      b.updateRecoil();
    }
  }

  // bắn đạn từ các barrel
  List<Bullet> fire() {
    final bullets = <Bullet>[];
    for (var b in barrels) {
      final bullet = b.fire(x, y, angle, tankRadius: radius, barrelLength: 40);
      if (bullet != null) {
        bullets.add(bullet);
        alpha = 1.0;
      }
    }
    return bullets;
  }

  void rotateTo(double joystickAngle) {
    angle = joystickAngle;
  }

  static const int minBarrel = 1;
  static const int maxBarrel = 12;

  /// Trả về null nếu thành công, trả về message nếu lỗi
  String? addBarrel() {
    if (barrels.length >= maxBarrel) {
      return 'Nòng súng đã đạt mức tối đa $maxBarrel!';
    }
    barrels.add(Barrel(angleOffset: (pi / 6) * barrels.length));
    return null;
  }

  String? removeBarrel() {
    if (barrels.length <= minBarrel) {
      return 'Tối thiểu phải có $minBarrel nòng súng!';
    }
    barrels.removeLast();
    return null;
  }
}
