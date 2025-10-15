import 'dart:math';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'entity.dart';

class Bullet {
  double x;
  double y;
  final double angle;
  final double size;
  final double speed;
  int lifetime;
  final int maxLife;
  final Color color;

  Bullet({
    required this.x,
    required this.y,
    required this.angle,
    required this.size,
    required this.speed,
    required this.lifetime,
    required this.color,
  }) : maxLife = lifetime;

  void update() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
    lifetime--;
  }

  bool get isDead => lifetime <= 0;

  double get alpha {
    if (lifetime < 20) return lifetime / 20;
    return 1.0;
  }
}
