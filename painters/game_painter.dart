import 'package:flutter/material.dart';
import '../game/game.dart';
// ignore: unused_import
import 'dart:math';

class GamePainter extends CustomPainter {
  final Game game;
  final Offset camOffset;
  GamePainter(this.game, this.camOffset);

  @override
  void paint(Canvas canvas, Size size) {
    // Camera lock: tank luôn ở giữa màn hình, camOffset đã truyền vào
    final t = game.tank;

    // bullets
    for (var b in game.bullets) {
      final paint = Paint()..color = b.color.withOpacity(b.alpha);
      canvas.drawCircle(Offset(b.x, b.y) + camOffset, b.size, paint);
    }

    // barrels (vẽ trước để nằm dưới hình tròn)
    for (var i = 0; i < t.barrels.length; i++) {
      final bar = t.barrels[i];
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(t.angle + bar.angleOffset);
      // Cộng thêm recoil vào vị trí vẽ nòng
      final recoilOffset = bar.recoil;
      final rect = Rect.fromLTWH(0 + recoilOffset, -6, 70, 12);
      canvas.drawRect(rect, Paint()..color = bar.color);
      canvas.restore();
    }

    // tank
    final paintTank = Paint()..color = t.color.withOpacity(t.alpha);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      t.size,
      paintTank,
    );

    // shapes
    for (var s in game.shapes) {
      final paint = Paint()..color = s.color;
      // Tạo màu viền đậm hơn bằng cách giảm lightness
      final hsl = HSLColor.fromColor(s.color);
      final borderColor = hsl
          .withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0))
          .toColor();
      final borderPaint = Paint()
        ..color = borderColor
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke;
      final center = Offset(s.x, s.y) + camOffset;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(s.angle);
      switch (s.type) {
        case 0: // tròn
          canvas.drawCircle(Offset.zero, s.size, paint);
          canvas.drawCircle(
            Offset.zero,
            s.size - 3,
            borderPaint,
          ); // viền bên trong
          break;
        case 1: // vuông
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: s.size * 2,
              height: s.size * 2,
            ),
            paint,
          );
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: s.size * 2 - 6,
              height: s.size * 2 - 6,
            ),
            borderPaint,
          );
          break;
        case 2: // tam giác đều
          final path = Path();
          final borderPath = Path();
          for (int i = 0; i < 3; i++) {
            final angle = (2 * 3.1415926535 * i / 3) - 3.1415926535 / 2;
            final dx = cos(angle) * s.size;
            final dy = sin(angle) * s.size;
            final dx2 = cos(angle) * (s.size - 3);
            final dy2 = sin(angle) * (s.size - 3);
            if (i == 0) {
              path.moveTo(dx, dy);
              borderPath.moveTo(dx2, dy2);
            } else {
              path.lineTo(dx, dy);
              borderPath.lineTo(dx2, dy2);
            }
          }
          path.close();
          borderPath.close();
          canvas.drawPath(path, paint);
          canvas.drawPath(borderPath, borderPaint);
          break;
        case 3: // ngũ giác đều
          final path = Path();
          final borderPath = Path();
          for (int i = 0; i < 5; i++) {
            final angle = (2 * 3.1415926535 * i / 5) - 3.1415926535 / 2;
            final dx = cos(angle) * s.size;
            final dy = sin(angle) * s.size;
            final dx2 = cos(angle) * (s.size - 3);
            final dy2 = sin(angle) * (s.size - 3);
            if (i == 0) {
              path.moveTo(dx, dy);
              borderPath.moveTo(dx2, dy2);
            } else {
              path.lineTo(dx, dy);
              borderPath.lineTo(dx2, dy2);
            }
          }
          path.close();
          borderPath.close();
          canvas.drawPath(path, paint);
          canvas.drawPath(borderPath, borderPaint);
          break;
        default:
          canvas.drawCircle(Offset.zero, s.size, paint);
          canvas.drawCircle(Offset.zero, s.size - 3, borderPaint);
      }
      canvas.restore();

      // health bar
      if (s.health < s.maxHealth) {
        final barW = s.size * 2;
        final rectBack = Rect.fromLTWH(
          s.x - s.size + camOffset.dx,
          s.y + s.size + 6 + camOffset.dy,
          barW,
          6,
        );
        canvas.drawRect(rectBack, Paint()..color = Colors.red.shade900);
        final rectFg = Rect.fromLTWH(
          rectBack.left,
          rectBack.top,
          barW * (s.health / s.maxHealth),
          6,
        );
        canvas.drawRect(rectFg, Paint()..color = Colors.green);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
