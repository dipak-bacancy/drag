import 'package:drag/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _widgets = [];

  int _count = 0;

  final _items = Map<int, Item>();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _widgets.add(Drag(
            id: _count++,
            valueChanged: (item) {
              _items.putIfAbsent(item.id, () => item);
            },
          ));
          setState(() {});

          print('---------------------------------------------------');
          print(_items);
          print('---------------------------------------------------');
        },
        child: Icon(Icons.add),
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
            },
            child: Container(
              height: 100,
              width: 200,
              child: _edit
                  ? TextFormField(
                      controller: _Controller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              text = _Controller.text;
                              _edit = false;

                              widget.valueChanged(Item(
                                  id: widget.id, x: left, y: top, text: text));
                            });
                          },
                          icon: Icon(Icons.done),
                        ),
                      ),
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
