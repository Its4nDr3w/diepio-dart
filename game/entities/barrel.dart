import 'package:flutter/material.dart';
import '../core/settings.dart';
import 'bullet.dart';
import 'dart:math';

class Barrel {
  final double angleOffset;
  final Color color;
  int reload = 0;
  double recoil = 0.0; // hiệu ứng giật nòng

  Barrel({this.angleOffset = 0, this.color = Colors.grey});

  Bullet? fire(
    double x,
    double y,
    double tankAngle, {
    double tankRadius = 32,
    double barrelLength = 40,
  }) {
    if (reload > 0) {
      reload--;
      return null;
    }
    reload = 15; // 15 frame cooldown
    recoil = -12.0; // giật về sau khi bắn

    final angle = tankAngle + angleOffset;
    // Đầu nòng: từ tâm tank ra mép hình tròn + chiều dài nòng
    final bulletX = x + cos(angle) * (tankRadius + barrelLength);
    final bulletY = y + sin(angle) * (tankRadius + barrelLength);
    return Bullet(
      x: bulletX,
      y: bulletY,
      angle: angle,
      size: GameSettings.bulletSize,
      speed: GameSettings.bulletSpeed,
      lifetime: GameSettings.bulletLife,
      color: Colors.white,
    );
  }

  void updateRecoil() {
    if (recoil < 0) {
      recoil += 2.5; // tốc độ hồi lại
      if (recoil > 0) recoil = 0;
    }
  }
}
