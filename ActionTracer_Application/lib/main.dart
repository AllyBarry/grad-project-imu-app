import 'package:flutter/material.dart';
import 'otherpage.dart';
import 'datapage.dart';
import 'logfiles.dart';
import 'package:attempt_20/ui/screen_names.dart' as ScreenNames;
import 'package:attempt_20/ui/ble_devices_screen.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'globals.dart' as globals;
import 'offline_storage.dart';
import 'package:flutter/material.dart';
import 'package:attempt_20/database/dbhelper.dart';
import 'package:attempt_20/model/LogItem.dart';
import 'package:attempt_20/logs_list.dart';

const Color polideaColor =  const Color.fromRGBO(25, 159, 217, 1.0);
void main() {
  runApp(new MaterialApp(
      home: new Application(title: 'ActionTracer Application'),
      /*onGenerateRoute: (RouteSettings settings){
        return new MaterialPageRoute(
          builder: (context){
            return DataList();
        };
        );
      },*/
      theme: new ThemeData(
        canvasColor: Colors.grey,
        iconTheme: new IconThemeData(color: Colors.white),
        accentColor: Colors.cyanAccent,
        brightness: Brightness.dark,
        ),
    routes: <String, WidgetBuilder>{
        ScreenNames.bleDevicesScreen: (
            BuildContext context) => new BleDevicesScreen(),
    },
  ));
}

class Application extends StatefulWidget {
  Application({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ApplicationState createState() => new _ApplicationState();

}

class _ApplicationState extends State<Application> {

  LogItem employee = new LogItem("", 0,[0] );

  String idName;
  int time =0;
  List<int> emailId;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
          title: new Text('Saving Employee'),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.view_list),
              tooltip: 'Next choice',
              onPressed: () {
                navigateToEmployeeList();
              },
            ),
          ]
      ),
      drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text('Alexandra Barry'),
                accountEmail: new Text('email@gmail.com'),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: new Text('A'),
                ),
                decoration: new BoxDecoration(color: Colors.orange),
              ),
              new ListTile(
                title: new Text('Activity Logs'),
                trailing: new Icon(Icons.arrow_forward),
                onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new logs())),
              ),
              new ListTile(
                title: new Text('Scan Page'),
                trailing: new Icon(Icons.arrow_forward),
                onTap: ()=> //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Scan())),
                  FlutterBleLib.instance.createClient(null).then(
                          (data) =>
                          Navigator.of(context).pushNamed(
                              ScreenNames.bleDevicesScreen)
                  ),
              ),
          //    new ListTile(
          //      title: new Text('Data Page'),
          //      trailing: new Icon(Icons.arrow_forward),
         //       onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new OffLine())),
        //      ),
              new ListTile(
                title: new Text('Close'),
                trailing: new Icon(Icons.close),
                onTap: (){Navigator.pop(context);},
              ),
            ],
          )
      ),

      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'First Name'),
                validator: (val) =>
                val.length == 0 ?"Enter FirstName" : null,
                onSaved: (val) => this.idName = val,
              ),
//              new TextFormField(
//                keyboardType: TextInputType.int,
//                decoration: new InputDecoration(labelText: 'Last Name'),
//                validator: (val) =>
//                val.length ==0 ? 'Enter LastName' : null,
//                onSaved: (val) => this.time = val,
//              ),
//              new TextFormField(
//                keyboardType: TextInputType.phone,
//                decoration: new InputDecoration(labelText: 'Mobile No'),
//                validator: (val) =>
//                val.length ==0 ? 'Enter Mobile No' : null,
//                onSaved: (val) => this.mobileno = val,
//              ),
//              new TextFormField(
//                keyboardType: TextInputType.emailAddress,
//                decoration: new InputDecoration(labelText: 'Email Id'),
//                validator: (val) =>
//                val.length ==0 ? 'Enter Email Id' : null,
//                onSaved: (val) => this.emailId = val,
//              ),
              new Container(margin: const EdgeInsets.only(top: 10.0),child: new RaisedButton(onPressed: _submit,
                child: new Text('Login'),),)

            ],
          ),
        ),
      ),
    );
  }
  void _submit() {
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save();
    }else{
      return null;
    }
    var employee = LogItem(idName,time,emailId);
    var dbHelper = DBHelper();
    dbHelper.saveEmployee(employee);
    _showSnackBar("Data saved successfully");
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void navigateToEmployeeList(){
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MyEmployeeList(context)),
    );
  }

}