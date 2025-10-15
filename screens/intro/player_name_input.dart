import 'package:flutter/material.dart';

class PlayerNameInput extends StatelessWidget {
  final String playerName;
  final ValueChanged<String> onChanged;
  const PlayerNameInput({
    super.key,
    required this.playerName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Tên người chơi',
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
