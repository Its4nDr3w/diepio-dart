import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final List<Color> colorOptions;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  const ColorPicker({
    super.key,
    required this.colorOptions,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: colorOptions
          .map(
            (color) => GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedColor == color
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
