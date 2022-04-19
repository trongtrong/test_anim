import 'package:flutter/material.dart';

import 'lib/src/simple_stack.dart';

class UndoRedoScreen extends StatefulWidget {
  const UndoRedoScreen({Key? key}) : super(key: key);

  @override
  _UndoRedoScreenState createState() => _UndoRedoScreenState();
}

class _UndoRedoScreenState extends State<UndoRedoScreen> {
  late SimpleStack _controller;

  @override
  void initState() {
    _controller = SimpleStack<int>(
      0,
      onUpdate: (val) {
        if (mounted)
          setState(() {
            print('New Value -> $val');
          });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count = _controller.state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Undo/Redo Example'),
      ),
      body: Center(
        child: Text('Count: $count'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: !_controller.canUndo
                  ? null
                  : () {
                      if (mounted)
                        setState(() {
                          _controller.undo();
                        });
                    },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: !_controller.canRedo
                  ? null
                  : () {
                      if (mounted)
                        setState(() {
                          _controller.redo();
                        });
                    },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: ValueKey('add_button'),
        child: Icon(Icons.add),
        onPressed: () {
          _controller.modify(count + 1);
        },
      ),
    );
  }
}
