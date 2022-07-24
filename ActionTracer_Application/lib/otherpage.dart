import 'package:flutter/material.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;

class op extends StatefulWidget {

  @override
  _opState createState() => new _opState();
}

class _opState extends State<op> {



  String ptext = '';
  void method1(value){
    setState(() {
      ptext = value;

      final test = new NewText(ptext);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Button Test Page'),),
        body: new Center(
          child: new Column(
          children: <Widget>[

            new Text(ptext),

            new RaisedButton(
                onPressed: (){
              method1('Button 1');
              //globals.connected = true;
            },
              child: new Text('Button 1'),),

            new RaisedButton(
              onPressed: (){
                method1('Button 2');
                //globals.connected = false;
              },
              child: new Text('Button 2'),),

            new RaisedButton(
              onPressed: (){
                method1('Button 3');
              },
              child: new Text('Button 3'),),

        ])
        )
    );
  }
}

class ButtonOne{}
class NewText{
  String buttonNumber;
  NewText(this.buttonNumber);
}
