import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:test_project/open_chest_screen.dart';
import 'package:test_project/src/core/core.dart';
import 'package:test_project/src/wheel/wheel.dart';
import 'package:test_project/undoRedo/lib/src/simple_stack.dart';
import 'package:test_project/undoRedo/undo_redo_screen.dart';
import 'package:test_project/widdget/gauge_widget.dart';
import 'package:test_project/widdget/slider_painter.dart';

void main() {
  runApp(MaterialApp(
    title: 'Test',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Animaition'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(width, 100.0),
          painter: SliderPainter(
            max: 100,
            min: 0,
            progress: 20
          ),
        ) ,


        /*CircularPercentIndicator(
          radius: 120.0,
          animation: true,
          animationDuration: 500,
          lineWidth: 10.0,
          percent: 0.5,
          reverse: false,
          arcBackgroundColor: Colors.blue,
          arcType: ArcType.FULL,
          center: Text(
            "20 hours",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.transparent,
          progressColor: Colors.cyan,
        ),*/



        /*CustomPaint(
          size: Size(100.0, 100.0),
          painter: GaugePainter(),
        ),*/
      ),

      /*Container(
          alignment: Alignment.center,
          width: 200,
          height: 200,
          child: Stack(fit: StackFit.expand, children: [
            for (int i = 0; i < colors.length; i++)
              Transform.rotate(
                angle: i * anglePerSlice,
                alignment: Alignment.topLeft,
                child: CustomPaint(
                  painter: CircleSlicePainter(
                    anglePerSlice,
                    colors[i],
                  ),
                ),
              )
          ]),
        ),*/
    );
  }
}

class CircleSlicePainter extends CustomPainter {
  final double angle;
  final Color color;

  const CircleSlicePainter(this.angle, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height);
    final path = buildSlicePath(radius, angle);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CircleSliceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleSlicePainter(pi / 2, Colors.blue),
    );
  }
}

Path buildSlicePath(double radius, double angle) {
  return Path()
    ..moveTo(0, 0)
    ..lineTo(radius, 0)
    ..arcTo(
      Rect.fromCircle(
        center: Offset(0, 0),
        radius: radius,
      ),
      0,
      angle,
      false,
    )
    ..close();
}
