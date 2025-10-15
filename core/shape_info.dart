// import 'package:flutter/material.dart';

// class ShapeInfo {
//   final int type;
//   final int sides; // Số cạnh (3: tam giác, 4: vuông, 5: ngũ giác, 0: tròn)
//   final double maxHealth;
//   final double expReward;
//   final int score;
//   final Color color;
//   final String name;

//   const ShapeInfo({
//     required this.type,
//     required this.sides,
//     required this.maxHealth,
//     required this.expReward,
//     required this.score,
//     required this.color,
//     required this.name,
//   });

//   static const List<ShapeInfo> all = [
//     ShapeInfo(
//       type: 0,
//       sides: 0, // tròn
//       maxHealth: 100,
//       expReward: 10,
//       score: 10,
//       color: Colors.blue,
//       name: 'Circle',
//     ),
//     ShapeInfo(
//       type: 1,
//       sides: 4, // vuông
//       maxHealth: 180,
//       expReward: 18,
//       score: 20,
//       color: Colors.green,
//       name: 'Square',
//     ),
//     ShapeInfo(
//       type: 2,
//       sides: 3, // tam giác
//       maxHealth: 250,
//       expReward: 25,
//       score: 30,
//       color: Colors.orange,
//       name: 'Triangle',
//     ),
//     ShapeInfo(
//       type: 3,
//       sides: 5, // ngũ giác
//       maxHealth: 400,
//       expReward: 40,
//       score: 50,
//       color: Colors.purple,
//       name: 'Pentagon',
//     ),
//   ];

//   static ShapeInfo byType(int type) {
//     return all.firstWhere(
//       (info) => info.type == type,
//       orElse: () => ShapeInfo(
//         type: 0,
//         sides: 0,
//         maxHealth: 100,
//         expReward: 10,
//         score: 10,
//         color: Colors.grey,
//         name: 'Unknown',
//       ),
//     );
//   }
// }
