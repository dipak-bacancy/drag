import 'dart:async';

import 'package:drag/item.dart';
import 'package:drag/picker.dart';
import 'package:drag/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tapioca/tapioca.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Picker(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.video}) : super(key: key);

  final video;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _widgets = [];

  int _count = 0;

  final _items = Map<int, Item>();

  final tapiocaBalls = <TapiocaBall>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          ..._widgets,
        ],
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _widgets.add(Drag(
                id: _count++,
                valueChanged: (item) {
                  _items.putIfAbsent(item.id, () => item);
                },
              ));
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () async {
//

              _items.values.forEach((element) {
                final item = TapiocaBall.textOverlay(
                    element.text,
                    element.x.toInt(),
                    element.y.toInt(),
                    100,
                    Color(0xffffc0cb));
                tapiocaBalls.add(item);
              });

              var tempDir = await getTemporaryDirectory();
              final path = '${tempDir.path}/result.mp4';

              final cup = Cup(Content(widget.video.path), tapiocaBalls);

              cup.suckUp(path).then((_) {
                print("finish processing");
              });

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VideoScreen(path)));
            },
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}

class Drag extends StatefulWidget {
  Drag({Key key, this.id, this.valueChanged}) : super(key: key);

  final ValueChanged<Item> valueChanged;
  final int id;

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  double top = 0;
  double left = 0;

  bool _draged = false;

  bool _edit = false;
  String text = 'Text';

  // ignore: non_constant_identifier_names
  final _Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _draged == false ? Alignment.center : Alignment(-1, -1),
      child: Draggable(
        child: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _edit = true;
              });
              const timeout = Duration(seconds: 6);

              return Timer(timeout, () {
                setState(() {
                  text = _Controller.text;
                  _edit = false;

                  widget.valueChanged(
                      Item(id: widget.id, x: left, y: top, text: text));
                });
              });
            },
            child: Container(
              height: 100,
              width: 200,
              child: _edit
                  ? TextFormField(
                      controller: _Controller,
                      decoration: InputDecoration(),
                    )
                  : Text(text),
            ),
          ),
        ),
        feedback: Container(),
        childWhenDragging: Container(),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          setState(() {
            top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
            left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;

            _draged = true;

            widget
                .valueChanged(Item(id: widget.id, x: left, y: top, text: text));
          });
        },
      ),
    );
  }
}
