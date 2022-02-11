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
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 12.0,
            children: List.generate(9, (index) {
              return Visibility(
                visible: !selectedList.contains(index),
                child: InkWell(
                  onTap: () {
                    setState(() {
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
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 12.0,
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

          Center(
            child: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Container(
                color: Colors.pink.withOpacity(0.5),
                width: 20,
                height: 20,
              ),
            ),
          )
        ]),
      ),
      TextButton(key: centerKey, onPressed: () {
        setState(() {
          selectedList.clear();
        });
      }, child: Text('Test Click'))
    ]));
  }

  void startCoinItem(int index, Point tartgetPoint, Point itemPoint) {
    highlightControllerList[index].reset();

    Tween tweenTransX = Tween(begin: 0.0, end:  tartgetPoint.x - itemPoint.x);
    // tweenTransList.add(tweenTransX);
    double value = tartgetPoint.y - itemPoint.y - 100.0;
    print('Value Anim ===     ${value}       tartgetPoint.y =    ${tartgetPoint.y}');
    Tween tweenTransY = Tween(begin: 0.0, end:  value);
    // tweenTransList.add(tweenTransY);
    Tween tweenScale = Tween(begin: 1.0, end: 1.0);
    // tweenScaleList.add(tweenScale);

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
    Offset position = box.localToGlobal(Offset.zero); //this is global position
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
