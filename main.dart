import 'package:flutter/material.dart';
// ignore: unused_import
import 'widgets/game_canvas.dart';
import 'screens/end_screen.dart';
import 'screens/intro_screen.dart';

// Removed duplicate imports

/// Entry point của ứng dụng Tank Game
void main() {
  runApp(const TankGameApp());
}

/// Widget gốc của game, cấu hình theme và màn hình chính
class TankGameApp extends StatefulWidget {
  const TankGameApp({super.key});

  @override
  State<TankGameApp> createState() => _TankGameAppState();
}

enum GameScreen { intro, game, end }

class _TankGameAppState extends State<TankGameApp> {
  GameScreen currentScreen = GameScreen.intro;
  String playerName = '';
  Color tankColor = Colors.blue;
  int score = 0;
  int level = 1;

  void startGame(String name, Color color) {
    setState(() {
      playerName = name;
      tankColor = color;
      currentScreen = GameScreen.game;
      score = 0;
      level = 1;
    });
  }

  void endGame(int finalScore, int finalLevel) {
    setState(() {
      score = finalScore;
      level = finalLevel;
      currentScreen = GameScreen.end;
    });
  }

  void restartGame() {
    setState(() {
      currentScreen = GameScreen.intro;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (currentScreen) {
      case GameScreen.intro:
        body = IntroScreen(onStart: startGame);
        break;
      case GameScreen.game:
        body = GameCanvas(
          onEnd: endGame,
          playerName: playerName,
          tankColor: tankColor,
        );
        break;
      case GameScreen.end:
        body = EndScreen(score: score, level: level, onRestart: restartGame);
        break;
    }
    return MaterialApp(
      title: 'Tank Game OOP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(body: SafeArea(child: body)),
    );
  }
}
