import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:test_project/open_chest_screen.dart';
import 'package:test_project/src/core/core.dart';
import 'package:test_project/src/wheel/wheel.dart';

void main() {
  runApp(MaterialApp(
    title: 'Test',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final colors = <Color>[
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.indigo,
    Colors.deepOrange,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    double anglePerSlice = 2 * pi / colors.length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Animaition'),
      ),
      body: Center(
        child:  CustomMultiChildLayout(
          delegate: YourLayoutDelegate(),
          children: <Widget>[
            LayoutId(
              id: 1, // The id can be anything, i.e. any Object, also an enum value.
              child: Text(
                  'Widget one'), // This is the widget you actually want to show.
            ),
            LayoutId(
              id: 2, // You will need to refer to that id when laying out your children.
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Widget two'),
              ),
            ),
          ],
        ),
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

class YourLayoutDelegate extends MultiChildLayoutDelegate {
  // You can pass any parameters to this class because you will instantiate your delegate
  // in the build function where you place your CustomMultiChildLayout.
  // I will use an Offset for this simple example.

  YourLayoutDelegate({this.position});

  final Offset? position;

  @override
  void performLayout(Size size) {
    // `size` is the size of the `CustomMultiChildLayout` itself.

    Size leadingSize = Size
        .zero; // If there is no widget with id `1`, the size will remain at zero.
    // Remember that `1` here can be any **id** - you specify them using LayoutId.
    if (hasChild(1)) {
      leadingSize = layoutChild(
        1, // The id once again.
        BoxConstraints.tightFor(
            height: size
                .height/2), // This just says that the child cannot be bigger than the whole layout.
      );
      // No need to position this child if we want to have it at Offset(0, 0).
    }

    if (hasChild(2)) {
      final secondSize = layoutChild(
        2,
        BoxConstraints.tightFor(width: size.width/2),
      );

      positionChild(
        2,
        Offset(
          leadingSize.width, // This will place child 2 to the right of child 1.
          0, // Centers the second child vertically.
        ),
      );
    }
  }

  @override
  bool shouldRelayout(YourLayoutDelegate oldDelegate) {
    return oldDelegate.position != position;
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
