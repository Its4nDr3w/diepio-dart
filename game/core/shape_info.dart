import 'package:flutter/material.dart';

class ShapeInfo {
  final int type; // 0=square, 1=triangle, 2=pentagon, 3=big pentagon
  final double maxHealth;
  final double expReward;
  final int score;
  final Color color;
  final String name;

  const ShapeInfo({
    required this.type,
    required this.maxHealth,
    required this.expReward,
    required this.score,
    required this.color,
    required this.name,
  });

  static const List<ShapeInfo> all = [
    ShapeInfo(
      type: 0,
      maxHealth: 100,
      expReward: 100,
      score: 1,
      color: Colors.yellow,
      name: 'Square',
    ),
    ShapeInfo(
      type: 1,
      maxHealth: 150,
      expReward: 150,
      score: 2,
      color: Colors.red,
      name: 'Triangle',
    ),
    ShapeInfo(
      type: 2,
      maxHealth: 200,
      expReward: 200,
      score: 3,
      color: Colors.blue,
      name: 'Pentagon',
    ),
    ShapeInfo(
      type: 3,
      maxHealth: 300,
      expReward: 500,
      score: 4,
      color: Colors.purple,
      name: 'Big Pentagon',
    ),
  ];

  static ShapeInfo byType(int type) {
    return all.firstWhere((info) => info.type == type, orElse: () => all[0]);
  }
}
