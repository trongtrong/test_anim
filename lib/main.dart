import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

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
  List<AnimationController> _controllerList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 9; i++) {
      itemKeys.add(GlobalKey());
      _controllerList.add(AnimationController(vsync: this, duration: const Duration(milliseconds: 5000)));
    }

    initHighlightAnim();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).viewPadding;
    // double widthItem = (MediaQuery.of(context).size.width - 32 - 32) / 3 - 16;
    double space = (height - padding.top - padding.bottom - 300 - 150 - 32);
    print('Height ==   ${height}    pad top == ${padding.top}     pad bottom ==   ${padding.bottom}     real heoght ==   ${space}');

    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 100,
                  color: Colors.black26,
                ),
              ),
            ),
            Positioned.fill(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.amberAccent.withOpacity(0.1),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.only(top: space/4 - 25 + 100),
                color: Colors.pink.withOpacity(0.4),
                child: Stack(children: [
                  //real list
                  AnimationLimiter(
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: false,
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: List.generate(9, (index) {
                        return Visibility(
                          visible: !selectedList.contains(index),
                          child: AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 800),
                            columnCount: 3,
                            child: SlideAnimation(
                              verticalOffset: -100.0,
                              child: FadeInAnimation(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      highlightControllerList[index].reset();
                                      selectedList.clear();
                                      selectedList.add(index);

                                      _controllerList[index].reset();
                                      // _controllerList[index].forward();
                                      _controllerList[index].value = 0.0;
                                      _controllerList[index].repeat(
                                        min: 0.0,
                                        max: 0.1,
                                        reverse: false,
                                        period: _controllerList[index].duration * (0.1 - 0.0),
                                      );

                                      highlightControllerList[index].addStatusListener((status) {
                                        if((status == AnimationStatus.reverse)){
                                          print('Animation reverse...............');

                                          _controllerList[index].stop();

                                          for(int i = 0; i < _controllerList.length; i++){
                                            if(i == index){
                                              continue;
                                            }
                                            _controllerList[i].reset();
                                            _controllerList[i].forward();

                                          }


                                  }

                                      });

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
                                    child: Lottie.asset(
                                      'assets/open_chest.json',
                                      controller: _controllerList[index],
                                      animate: false,
                                      onLoaded: (composition) {
                                        // Configure the AnimationController with the duration of the
                                        // Lottie file and start the animation.
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  selectedList.isNotEmpty ?
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ) : Container(),

                  //fake list
                  selectedList.isNotEmpty
                      ? GridView.count(
                    padding: EdgeInsets.zero,
                    shrinkWrap: false,
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: List.generate(9, (index) {
                      return Visibility(
                        visible: selectedList.contains(index),
                        child: InkWell(
                          key: itemKeys[index],
                          onTap: () {
                            setState(() {
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
                                    child: Lottie.asset(
                                      'assets/open_chest.json',
                                      animate: false,
                                      controller: _controllerList[index],
                                      onLoaded: (composition) {
                                        // Configure the AnimationController with the duration of the
                                        // Lottie file and start the animation.
                                      },
                                    ),
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
            ),
            Positioned.fill(
              bottom: 100,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          highlightControllerList[selectedList.first].reverse();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.brown,
                        width: 100,
                        height: 100,
                        child: Text('Reverse'),
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ]
        ));
  }

  void startCoinItem(int index, Point tartgetPoint, Point itemPoint) {
    Tween tweenTransX = Tween(begin: 0.0, end: tartgetPoint.x - itemPoint.x - 18);
    double value = tartgetPoint.y - itemPoint.y - size.height - 25;
    print('Value Anim ===     ${value}       size.height =    ${size.height}');
    Tween tweenTransY = Tween(begin: 0.0, end: value);
    Tween tweenScale = Tween(begin: 1.0, end: 1.0);

    highlightAnimationList[index] = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: tweenTransX,
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 550),
            tag: "transX")
        .addAnimatable(
            animatable: tweenTransY,
            from: const Duration(seconds: 0),
            to: const Duration(milliseconds: 550),
            tag: "transY",
            curve: Curves.easeInBack)
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
