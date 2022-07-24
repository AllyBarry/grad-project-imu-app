import 'package:flutter/material.dart';

class OffLine extends StatefulWidget {
  @override
  _OffLineState createState() => _OffLineState();
}

class _OffLineState extends State<OffLine> {

  String ptext = '';
  String ptext_1 = '';

  void method1(value){
    setState(() {
      ptext = value;
    });
  }
  void method2(value){
    setState(() {
      ptext_1 = value;
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


//class LogProvider {
//  Database db;
//
//  init() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    final path = join(documentsDirectory.path, "items.db");
//    db = await openDatabase(
//        path,
//        version: 1,
//        onCreate: (Database newDb, int version){
//          newDb.execute("""
//        CREATE TABLE Items
//        (
//          id INTEGER PRIMARY KEY,
//          time INTEGER,
//          text TEXT,
//          accX BLOB,
//        )
//        """);
//        }
//    );
//  }
//
//  Future<ItemModel> fetchItem(int id) async {
//    final maps = await db.query(
//      "Items",
//      columns: null,
//      where: "id = ?",
//      whereArgs: [id],
//    );
//
//    if (maps.length > 0){
//      return ItemModel.fromDb(maps.first);
//    }
//
//    return null;
//  }
//
//  Future<int> addItem(ItemModel item){
//    return db.insert("Items", item.toMap());
//  }
//
//}
//
//class ItemModel {
//  final int id;
//  // final int time;
//  final String text;
//  // final List<dynamic> accX;
//  ItemModel(this.id, this.text);
//
////  ItemModel.fromDb(Map<String, dynamic> parsedJson)
////      : id = parsedJson['id'],
////  // time = parsedJson['time'],
////        text = parsedJson['text'];
////  // accX = jsonDecode(parsedJson['kids']);
////
////  Map<String, dynamic> toMap() {
////    return <String, dynamic>{
////      "id": id,
////      //   "time": time,
////      "text": text,
////      //    "accX": jsonEncode(accX),
////    };
////  }
//}
//
//class Repository {
//  LogProvider logProvider = LogProvider();
//
//  Future<ItemModel> fetchItem(int id) async {
//    var item = await logProvider.fetchItem(id);
//    if (item != null){
//      return item;
//    }
//
//    //item = await apiProvider.fetchItem(id);
//    logProvider.addItem(item);
//
//    return item;
//  }
//
//}