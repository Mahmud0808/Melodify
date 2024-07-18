import 'package:flutter/material.dart';
import 'package:melodify/utility/constants/colors.dart';

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorBackground,
      ),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }
}
