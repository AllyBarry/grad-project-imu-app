import 'package:flutter/material.dart';

class customwidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.pink,
      child: new Container(
        color: Colors.orange,
        margin: const EdgeInsets.all(15.0),
        child: new Container(
          color: Colors.blue,
          margin: const EdgeInsets.all(15.0),
          child: _methodcustom(),
        ),
      ),

    );
  }
}

Widget _methodcustom(){
  return new Container(
    color: Colors.purple,
    margin: const EdgeInsets.all(15.0),
  );
}