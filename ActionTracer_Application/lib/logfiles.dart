import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';
import 'globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;

class logs extends StatelessWidget {

 static List<MockBandInfo> _bandList = [
    new MockBandInfo(name: "Name 1", votes: 1),
    new MockBandInfo(name: "Name 2", votes: 2),
    new MockBandInfo(name: "Name 3", votes: 3),
    new MockBandInfo(name: "Name 4", votes: 4),
  ];


//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(title: new Text('Activity Logs'),),
//      body: new ListView.builder(
//              itemExtent: 80.0,
//              itemCount: _bandList.length,
//              itemBuilder: (context, index) =>
//                  _buildListItem(context, _bandList[index]),
//      ),
//    );
//  }

//  Widget _buildListItem(BuildContext context, MockBandInfo bandInfo, DocumentSnapshot document){
//    return new ListTile(
//      title: new Row(
//        children: <Widget>[
//          new Expanded(
//            child: new Text(
//              bandInfo.name,
//              style: Theme.of(context).textTheme.headline,
//            ),
//          ),
//          new Container(
//            decoration: const BoxDecoration(
//                color: Colors.cyan
//            ),
//            padding: const EdgeInsets.all(10.0),
//            child: new Text(
//              bandInfo.votes.toString(),
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ),
//        ],
//      ),
//      onTap: (){
//        print("Test Text Section");
//      },
//    );
//  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(title: new Text('Activity Logs'),),
        body: new StreamBuilder (
          stream: Firestore.instance.collection('ActivityLogs').snapshots,
          builder: (context, snapshot){
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
            itemExtent: 80.0,
              //itemCount: 3,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
            _buildListItem(context, snapshot.data.documents[index]),
            );
            }),

    );
  }
//
  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              document['name'],
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Container(
            decoration: const BoxDecoration(
              color: Colors.cyan
              ),
          padding: const EdgeInsets.all(10.0),
          child: new Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.display1,
              ),
           ),
        ],
      ),
      onTap: (){
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
              await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'votes': freshSnap['votes']+1,
          });
        });
        //document.reference.updateData({
      //   'votes': document['votes']+1
     //   });
      },
    );
  }

}

class MockBandInfo {
  const MockBandInfo({this.name, this.votes});

  final String name;
  final int votes;
}
