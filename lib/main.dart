import 'package:flutter/material.dart';
import 'customw.dart';

void main() => runApp(new application());

class application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Custom Widgets',
      home: new Scaffold(
        body: new customwidgets(),
      ),
    );
  }
}
