import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'intro/title_widget.dart';
import 'intro/player_name_input.dart';
import 'intro/color_picker.dart';
import 'intro/tank_preview.dart';
import 'intro/start_button.dart';

class IntroScreen extends StatefulWidget {
  final void Function(String playerName, Color tankColor) onStart;
  const IntroScreen({super.key, required this.onStart});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  String playerName = '';
  Color tankColor = Colors.blue;
  final List<Color> colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.grey,
  ];

  double tankAngle = 0.0;
  late final Ticker _spinTicker;

  @override
  void initState() {
    super.initState();
    _spinTicker = createTicker((_) {
      setState(() {
        tankAngle += 0.03;
        if (tankAngle > 2 * pi) tankAngle -= 2 * pi;
      });
    });
    _spinTicker.start();
  }

  @override
  void dispose() {
    _spinTicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleWidget(),
          const SizedBox(height: 24),
          PlayerNameInput(
            playerName: playerName,
            onChanged: (val) => setState(() => playerName = val),
          ),
          const SizedBox(height: 24),
          const Text('Chọn màu xe tăng:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          ColorPicker(
            colorOptions: colorOptions,
            selectedColor: tankColor,
            onColorSelected: (color) => setState(() => tankColor = color),
          ),
          const SizedBox(height: 24),
          const Text('Preview:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TankPreview(color: tankColor, angle: tankAngle),
          const SizedBox(height: 32),
          StartButton(
            onPressed: playerName.trim().isEmpty
                ? null
                : () => widget.onStart(playerName.trim(), tankColor),
          ),
        ],
      ),
    );
  }
}
