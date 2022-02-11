import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //blinking
  List<SequenceAnimation> highlightAnimationList = [];
  List<AnimationController> highlightControllerList = [];
  List<int> selectedList = [];
  List<GlobalKey> itemKeys = [];
  GlobalKey centerKey = GlobalKey();

  Size size;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 9; i++) {
      itemKeys.add(GlobalKey());
    }

    initHighlightAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Stack(children: [
          //real list
          GridView.count(
            shrinkWrap: false,
            crossAxisCount: 3,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
            children: List.generate(9, (index) {
              return Visibility(
                visible: !selectedList.contains(index),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      highlightControllerList[index].reset();
                      selectedList.clear();
                      selectedList.add(index);
                    });

                    Future.delayed(Duration(milliseconds: 300), () {
                      Point itemPoint = getPosWidget(itemKeys[index]);
                      Point targetPoint = getPosWidget(centerKey);

                      print('itemPoint ==     ${itemPoint.x}    x    ${itemPoint.y}');
                      print('targetPoint ==     ${targetPoint.x}    x    ${targetPoint.y}');
                      print('------------------------------------------------------');

                      startCoinItem(index, targetPoint, itemPoint);
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: index % 2 == 0 ? Colors.red : Colors.green,
                  ),
                ),
              );
            }),
          ),

          //fake list
          selectedList.isNotEmpty
              ? GridView.count(
                  shrinkWrap: false,
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  children: List.generate(9, (index) {
                    return Visibility(
                      visible: selectedList.contains(index),
                      child: InkWell(
                        key: itemKeys[index],
                        onTap: () {
                          setState(() {
                            // selectedList.clear();
                            // selectedList.add(index);
                          });
                        },
                        child: AnimatedBuilder(
                          animation: highlightControllerList[index],
                          builder: (BuildContext context, Widget child) {
                            return Transform.scale(
                              scale: highlightAnimationList[index]["scale"].value,
                              child: Transform.translate(
                                offset: Offset(highlightAnimationList[index]["transX"].value,
                                    highlightAnimationList[index]["transY"].value),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: index % 2 == 0 ? Colors.yellow : Colors.cyan,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                )
              : Container(),
        ]),
      ),
      InkWell(
        key: centerKey,
        onTap: () {
          setState(() {
            selectedList.clear();
          });
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.brown,
          width: 100,
          height: 100,
          child: Text('Test Click'),
        ),
      ),
      Container(
        height: 200,
        color: Colors.amberAccent.withOpacity(0.1),
      )
    ]));
  }

  void startCoinItem(int index, Point tartgetPoint, Point itemPoint) {
    Tween tweenTransX = Tween(begin: 0.0, end: tartgetPoint.x - itemPoint.x - 25 / 2);
    double value = tartgetPoint.y - itemPoint.y - size.height - 25;
    print('Value Anim ===     ${value}       size.height =    ${size.height}');
    Tween tweenTransY = Tween(begin: 0.0, end: 100.0);
    Tween tweenScale = Tween(begin: 1.0, end: 2.0);

    highlightAnimationList[index] = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: tweenTransX,
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 550),
            tag: "transX",
            curve: Curves.easeIn)
        .addAnimatable(
            animatable: tweenTransY,
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 550),
            tag: "transY",
            curve: Curves.easeIn)
        .addAnimatable(
            animatable: tweenScale, from: Duration(milliseconds: 0), to: Duration(milliseconds: 550), tag: 'scale')
        .animate(highlightControllerList[index]);

    highlightControllerList[index].forward();
  }

  Point getPosWidget(GlobalKey key) {
    RenderBox box = key.currentContext.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is
    size = box.size; // global position
    double x = position.dx;
    double y = position.dy;

    return Point(x, y);
  }

  List<Tween> tweenTransList = [];
  List<Tween> tweenScaleList = [];

  void initHighlightAnim() {
    for (int i = 0; i < 9; i++) {
      AnimationController highlightController = AnimationController(vsync: this);

      Tween tweenTransX = Tween(begin: 0.0, end: 100.0);
      tweenTransList.add(tweenTransX);
      Tween tweenTransY = Tween(begin: 0.0, end: 100.0);
      tweenTransList.add(tweenTransY);
      Tween tweenScale = Tween(begin: 1.0, end: 2.0);
      tweenScaleList.add(tweenScale);

      SequenceAnimation highlightAnimation = SequenceAnimationBuilder()
          .addAnimatable(
              animatable: tweenTransX,
              from: const Duration(seconds: 0),
              to: const Duration(milliseconds: 550),
              tag: "transX",
              curve: Curves.easeIn)
          .addAnimatable(
              animatable: tweenTransY,
              from: const Duration(seconds: 0),
              to: const Duration(milliseconds: 550),
              tag: "transY",
              curve: Curves.easeIn)
          .addAnimatable(
              animatable: tweenScale, from: Duration(milliseconds: 0), to: Duration(milliseconds: 550), tag: 'scale')
          .animate(highlightController);

      highlightControllerList.add(highlightController);
      highlightAnimationList.add(highlightAnimation);
    }
  }
}
