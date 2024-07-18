import 'package:flutter/material.dart';
import 'package:melodify/utility/constants/colors.dart';

import '../../utility/glass_appbar.dart';
import '../../utility/widgets/icon_text_row.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: textColorPrimary,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          // TODO
        ],
      ),
    );
  }
}
