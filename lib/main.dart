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

  Widget temp;

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
          _widgets.add(Drag());
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Drag extends StatefulWidget {
  Drag({Key key}) : super(key: key);

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  double top = 0;
  double left = 0;

  bool _draged = false;

  @override
  Widget build(BuildContext context) {
    Widget item = DragItem();
    return Align(
      alignment: _draged == false ? Alignment.center : Alignment(-1, -1),
      child: Draggable(
        child: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: item,
        ),
        feedback: Container(
            padding: EdgeInsets.only(top: top, left: left), child: DragItem()),
        childWhenDragging: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: item,
        ),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          setState(() {
            top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
            left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;

            _draged = true;
          });
        },
      ),
    );
  }
}

class DragItem extends StatefulWidget {
  const DragItem({Key key}) : super(key: key);

  @override
  _DragItemState createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  bool _edit = false;
  String text = 'Text';

  final _Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  // labelText: 'Label text',
                  // errorText: '',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        text = _Controller.text;
                        _edit = false;
                      });
                    },
                    icon: Icon(Icons.done),
                  ),
                ),
              )
            : Text(text),
      ),
    );
  }
}
