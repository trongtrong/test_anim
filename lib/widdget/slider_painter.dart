import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  int progress;
  int max;
  int min;

  SliderPainter({required this.progress, required this.max, required this.min});

  @override
  void paint(Canvas canvas, Size size) {

    const halfThumb = 20.0;
    const heightBg = 6.0;
    double w = size.width - 32;
    double h = size.height;
    double r = 10;

    double value = normalize(progress, w);

    var paintBg = Paint()
      ..color = Color(0xffD3EDFF)
      ..style = PaintingStyle.fill;

    var paintActive = Paint()
      ..color = Color(0xff1F92FC)
      ..style = PaintingStyle.fill;

    var paintThumb = Paint()
      ..color = Color(0xff1F92FC)
      ..style = PaintingStyle.fill;

    var paintBorderThumb = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    //draw bg
    RRect bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(16, halfThumb / 2 -heightBg/2, w, heightBg),
      Radius.circular(r),
    );
    canvas.drawRRect(bg, paintBg);

    //draw active
    RRect active = RRect.fromRectAndRadius(
      Rect.fromLTWH(16, halfThumb / 2 - heightBg/2, value, heightBg),
      Radius.circular(r),
    );
    canvas.drawRRect(active, paintActive);

    //draw border thumb
    RRect borderThumb = RRect.fromRectAndRadius(
      Rect.fromLTWH(active.right - halfThumb - 2, 0, halfThumb * 2 + 4, 20),
      Radius.circular(r),
    );
    canvas.drawRRect(borderThumb, paintBorderThumb);

    //draw thumb
    RRect thumb = RRect.fromRectAndRadius(
      Rect.fromLTWH(active.right - halfThumb, 0, halfThumb * 2, 20),
      Radius.circular(r),
    );
    canvas.drawRRect(thumb, paintThumb);

    //draw Text

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 11,
    );
    final textSpan = TextSpan(
      text: '${progress}/${max}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: thumb.width,
    );
    final xCenter = (thumb.width - textPainter.width) / 2 + thumb.right - halfThumb * 2;
    final yCenter = (thumb.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double normalize(int progress, double width) {
    double value = (progress * width) / max;
    return value;
  }
}
