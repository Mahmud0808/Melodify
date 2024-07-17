import 'package:flutter/material.dart';

import 'constants/colors.dart';
import 'gradient_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgDarkColor.withAlpha(160),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.sort_rounded,
                color: whiteColor,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Me",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: whiteColor,
                      ),
                    ),
                    GradientText(
                      'lodify',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade300,
                          Colors.deepPurple.shade400,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
