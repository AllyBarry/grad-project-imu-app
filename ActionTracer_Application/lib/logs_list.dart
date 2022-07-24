import 'package:flutter/material.dart';
import 'package:attempt_20/model/LogItem.dart';
import 'dart:async';
import 'package:attempt_20/database/dbhelper.dart';
import 'offline_storage.dart';
import 'details_page.dart';
import 'package:attempt_20/details_page.dart';

Future<List<LogItem>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<LogItem>> employees = dbHelper.getEmployees();
  return employees;
}

class MyEmployeeList extends StatefulWidget {

  final BuildContext _mainBuildContext;
  MyEmployeeList(this._mainBuildContext);

  @override
  MyEmployeeListPageState createState() => new MyEmployeeListPageState(_mainBuildContext);
}

class MyEmployeeListPageState extends State<MyEmployeeList> {

  final BuildContext _mainBuildContext;
  MyEmployeeListPageState(this._mainBuildContext);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Employee List'),
      ),
      body:  new FutureBuilder<List<LogItem>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(

                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                  _buildListItem(_mainBuildContext, snapshot.data[index])
//                    return new Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          new Text(snapshot.data[index].firstName,
//                              style: new TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
//                          new Text(snapshot.data[index].lastName,
//                              style: new TextStyle(
//                                  fontWeight: FontWeight.bold, fontSize: 14.0)),
//                          new Divider()
//                        ]);


              );} else if (snapshot.data.length == 0) {
              return new Text("No Data found");
            }
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, LogItem employee){
    return new ListTile(
      title: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              employee.idName,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          new Container(
            decoration: const BoxDecoration(
                color: Colors.cyan
            ),
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.arrow_forward)
          ),
        ],
      ),
      onTap: (){
        Navigator.of(_mainBuildContext).push(new MaterialPageRoute(
            builder: (BuildContext buildContext) =>
            new Details(employee)));
      },
    );
  }

}