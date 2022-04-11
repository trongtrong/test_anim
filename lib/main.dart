import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vertical_marquee/flutter_vertical_marquee.dart';
import 'package:lottie/lottie.dart';
import 'package:test_project/open_chest_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Test',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Animaition'),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(100.0, 100.0),
          painter: GaugePainter(),
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter{
  Paint painter = Paint()
    ..color = Colors.teal
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    print('Size ==   ${size.width}      ${size.height}');


                        //Draw Arc
    //init rect value
    double left = 0.0;
    double top = 0.0;
    double right = left + size.width;
    double bottom = top + size.height;


    //draw arc background
    painter.color = const Color(0xffd3edff);
    canvas.drawArc(Rect.fromLTRB(left, top, right, bottom), degreesToRads(135.0), degreesToRads(270.0), false, painter);

    //draw arc progress
    painter.color = const Color(0xff1f92fc);
    canvas.drawArc(Rect.fromLTRB(left, top, right, bottom), degreesToRads(135.0), degreesToRads(180.0), false, painter);


    //draw arc child
    painter.color = const Color(0xff93c7f8);
    painter.strokeWidth = 2.0;
    canvas.drawArc(Rect.fromLTRB(left + 12, top + 12, right - 12, bottom - 12), degreesToRads(135.0), degreesToRads(270.0), false, painter);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  num degreesToRads(double deg) {
    return (deg * pi) / 180.0;
  }


}
