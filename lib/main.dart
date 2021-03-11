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
            color: Colors.blue,
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

  double _x;
  double _y;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment:
          _x == null && _y == null ? Alignment.center : Alignment(-1, -1),
      child: Draggable(
        child: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: DragItem(),
        ),
        feedback: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: Icon(
            Icons.run_circle,
            size: 40,
          ),
        ),
        childWhenDragging: Container(
          padding: EdgeInsets.only(top: top, left: left),
          child: DragItem(),
        ),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          setState(() {
            top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
            left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;

            _x = top / height;
            _y = left / width;
          });
        },
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  const DragItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Text('drag me'),
    );
  }
}
