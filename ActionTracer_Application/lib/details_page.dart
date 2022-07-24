import 'package:flutter/material.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:attempt_20/model/LogItem.dart';

class Details extends StatefulWidget {

  final LogItem log;
  Details(this.log);

  @override
  _DetailsState createState() => new _DetailsState(log);
}

class _DetailsState extends State<Details> {

  final LogItem log;
  _DetailsState(this.log);

  String ptext = '';
  String id = '';
  int time = 0;
  List<int> accX = [0];
  String email = '';

  void method1(value){
    setState(() {
      ptext = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    id = log.idName;
    time = log.time;
    accX = log.accX;

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
                  new Text("Log ID:"),
                  new Text(id),
                  new Text("Time:"),
                  new Text("$time"),
                  new Text("Data:"),
                  new Text("$accX"),



                ])
        )
    );
  }
}
