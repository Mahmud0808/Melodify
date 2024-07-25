import 'package:flutter/material.dart';

class PlayerSliderTrackShape extends RoundedRectSliderTrackShape {
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  PlayerSliderTrackShape({
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const trackHeight = 10.4;
    final trackLeft = offset.dx +
        margin.resolve(TextDirection.ltr).left +
        padding.resolve(TextDirection.ltr).left;
    final trackTop = offset.dy +
        (parentBox.size.height - trackHeight) / 2 +
        margin.resolve(TextDirection.ltr).top +
        padding.resolve(TextDirection.ltr).top;
    final trackWidth = parentBox.size.width -
        margin.resolve(TextDirection.ltr).horizontal -
        padding.resolve(TextDirection.ltr).horizontal;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class PlayerSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  PlayerSliderThumbShape({this.thumbRadius = 12.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectXY(
        Rect.fromCenter(
          center: center,
          width: 12,
          height: 12,
        ),
        thumbRadius,
        thumbRadius,
      ),
      paint,
    );
  }
}