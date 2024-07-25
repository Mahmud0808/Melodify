import 'dart:ui';

import 'package:flutter/material.dart';

import 'constants/colors.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingIcon;
  final Widget child;
  final Widget? trailingIcon;
  final bool isOpaque;

  @override
  Size get preferredSize => const Size.fromHeight(100);

  const GlassAppBar({
    super.key,
    this.leadingIcon,
    required this.child,
    this.trailingIcon,
      this.isOpaque = true});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(
        double.infinity,
        56.0,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: colorBackground.withAlpha(isOpaque ? 160 : 255),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(child: leadingIcon ?? Container()),
                    ),
                    Expanded(
                      child: child,
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(child: trailingIcon ?? Container()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
