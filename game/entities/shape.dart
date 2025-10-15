import 'dart:math';
import 'package:flutter/material.dart';
import '../core/shape_info.dart';
import 'entity.dart';

class Shape extends Entity {
  /// Cập nhật trạng thái shape mỗi frame: xoay và di chuyển
  void update() {
    angle += angleSpeed; // xoay
    if (angle > 2 * 3.1415926535) angle -= 2 * 3.1415926535;
    x += vx; // di chuyển
    y += vy;
  }

  double angle = 0.0; // góc xoay hiện tại
  double angleSpeed; // tốc độ xoay (radian/frame)
  double health; // máu hiện tại
  final int type; // loại shape (0: tròn, 1: vuông, ...)
  final ShapeInfo info; // thông tin shape (màu, exp, ...)

  double get size => radius; // kích thước shape
  double get maxHealth => info.maxHealth; // máu tối đa
  double get expReward => info.expReward; // exp thưởng khi bị hạ
  int get score => info.score; // điểm thưởng khi bị hạ
  Color get color => info.color; // màu shape
  String get name => info.name; // tên shape

  Shape({
    required double x,
    required double y,
    required double size,
    required this.health,
    required this.type,
    required this.info,
    double? angleSpeed,
  }) : angleSpeed =
           angleSpeed ??
           (0.0001 + Random().nextDouble() * 0.02), // tốc độ spin ngẫu nhiên
       super(x: x, y: y, vx: 0, vy: 0, radius: size, mass: 1.0);

  factory Shape.random(double width, double height) {
    // Chọn loại shape và kích thước ngẫu nhiên
    final rand = Random().nextDouble();
    int type;
    double size;
    if (rand < 0.7) {
      type = 0; // tròn
      size = 20;
    } else if (rand < 0.8) {
      type = 1; // vuông
      size = 28;
    } else if (rand < 0.95) {
      type = 2; // tam giác
      size = 36;
    } else {
      type = 3; // ngũ giác
      size = 52;
    }
    final info = ShapeInfo.byType(type);
    // Tạo shape mới với tốc độ spin ngẫu nhiên
    return Shape(
      x: width,
      y: height,
      size: size,
      health: info.maxHealth,
      type: type,
      info: info,
      angleSpeed: 0.0001 + Random().nextDouble() * 0.02, // tốc độ spin
    );
  }

  bool get isDead => health <= 0;
}
