import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../helpers.dart';

class TimeDisplay extends StatelessWidget {
  final double startTime;
  final double endTime;

  const TimeDisplay({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formatDuration(startTime),
              style: const TextStyle(
                fontSize: 13,
                color: textColorSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatDuration(endTime),
              style: const TextStyle(
                fontSize: 13,
                color: textColorSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
