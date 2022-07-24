import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:attempt_20/ui/button_widget.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:typed_data';

//UUIDS:
//Service:       00001234-0000-1000-8000-00805f9b34fb

class dataPage extends StatefulWidget {
  final BleDevice _connectedDevice;

  dataPage(this._connectedDevice);

  @override
  _dataPageState createState() => new _dataPageState(_connectedDevice);
}

class _dataPageState extends State<dataPage> {
  final BleDevice _connectedDevice;
  //final BleService _bleService;
  String _serviceDiscoveringState = "Unknown";
  double _serviceId = 7.0;
  int _serviceIndex = 2; //in list of discovered services: 0,1,2.. etc
  int _characteristicIndex = 0; //in list of characteristics

  int _counter = 0;
  int _value = 0;
  int buttVal = 0;
  double roll = 0.0;
  double accY = 0.0;
  //final List<charts.Series> seriesList;
  //final bool animate;

  _dataPageState(this._connectedDevice);


  String ptext = '';
  String rtext = '';
  String rtext_1 = '';
  String rtext_2 = '';

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.onDeviceConnectionChanged().listen((device) =>
        setState(() => _connectedDevice.isConnected = device.isConnected));
  }


  @override
  Widget build(BuildContext context) {
    var data = [
      new ChartData(0, (360-((roll+360)%360))/360*100, Colors.green),
      new ChartData(1, ((roll+360)%360)/360*100, Colors.red),
    ];

    var series = [
      new charts.Series<ChartData, int>(
        domainFn: (ChartData clickData, _) => clickData.barTime,
        measureFn: (ChartData clickData, _) => clickData.timeStep,
        colorFn: (ChartData clickData, _) => clickData.color,
        id: 'Clicks',
        data: data,
      ),
    ];

    var data_bar = [
      new BarData('X', roll),
      new BarData('Y', accY),
      new BarData('Z', roll),
    ];

    var seriesBar = [
      new charts.Series<BarData, String>(
        id: 'Acceleration',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarData data_b, _) => data_b.axis,
        measureFn: (BarData data_b, _) => data_b.data_b,
        data: data_bar,
      )
    ];

    var chart = new charts.PieChart(
      series,
      animate: false,
//
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 10, startAngle: 0.0)
    );

    var chartBar = new charts.BarChart(
      seriesBar,

    );

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 80.0,
        child: chart,
      ),
    );

    var chartWidget_Bar = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 120.0,
        child: chartBar,
      ),
    );

    final TextStyle buttonStyle = Theme
        .of(context)
        .textTheme
        .button;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("${_connectedDevice.name ?? "Unknown"} Device."),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[

             // new Text(_smallLabel()),
              new MaterialButton(
                onPressed: () => _onIsConnectedButtonClick(),
                color: Colors.blueAccent,
                child: new Text("START LOGGING"),
              ),
//              _button(
//                  "Discover all services", _onDiscoverAllServicesClick,
//                  buttonStyle),
         //     _button(
         //         "Increment Counter", _serviceDiscoveringState != "DONE" ? null :
         //         () => _incrementCounter(buttVal),
         //         buttonStyle),
              new Text(_serviceDiscoveringState),
             // new Text(ptext),
             // new Text(rtext),
              //new Text(rtext_1),
         // new Text(
           // 'You have pushed the button this many times:',
          //),
          //new Text(
            //'$_counter'),

                  chartWidget,
                 // chartWidget,



                  chartWidget_Bar,
                  //chartWidget,
            //  ),

            ],
          ),
        ));
  }

  _smallLabel() => "\tname : ${_connectedDevice.name}\n\tid : ${_connectedDevice
          .id}\n\tis connected : ${_connectedDevice
          .isConnected}";

  _onIsConnectedButtonClick() {
    FlutterBleLib.instance
        .isDeviceConnected(_connectedDevice.id)
        .then((isConnected) {
      setState(() {
        _connectedDevice.isConnected = isConnected;
      });
    });
    FlutterBleLib.instance.discoverAllServicesAndCharacteristicsForDevice(
        _connectedDevice.id)
        .then((device) {
      setState(() {
        _serviceDiscoveringState = "DONE";
      });
      FlutterBleLib.instance
          .servicesForDevice(_connectedDevice.id)
          .then((services) {
        FlutterBleLib.instance
            .characteristicsForService(_serviceId)
            .then((characteristics) {
          FlutterBleLib.instance.monitorCharacteristicForDevice(
              services[_serviceIndex].device.id,
              services[_serviceIndex].uuid,
              characteristics[_characteristicIndex].uuid,
              new Uuid().v1())
              .listen((value) => _action(value.characteristic.value));
        });
      });
    });
  }

  _button(String text, VoidCallback onPressed, TextStyle buttonStyle) =>
      new Container (
        margin: const EdgeInsets.only(bottom: 10.0),
        child: new CustomMaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          disabledColor: Colors.grey,
          child: new Text(text, style: buttonStyle),
        ),
      );


  _onDiscoverAllServicesClick() {
    FlutterBleLib.instance.discoverAllServicesAndCharacteristicsForDevice(
        _connectedDevice.id)
        .then((device) {
      setState(() {
        _serviceDiscoveringState = "DONE";
      });
      FlutterBleLib.instance
          .servicesForDevice(_connectedDevice.id)
          .then((services) {
        FlutterBleLib.instance
            .characteristicsForService(_serviceId)
            .then((characteristics) {
          FlutterBleLib.instance.monitorCharacteristicForDevice(
              services[_serviceIndex].device.id,
              services[_serviceIndex].uuid,
              characteristics[_characteristicIndex].uuid,
              new Uuid().v1())
              .listen((value) => _action(value.characteristic.value));
        });
        });
    });
  }



  _action(String value) {
    final List<int> newVal = base64.decode(value);
    setState(() {
      //buttVal = newVal[0];
      ByteBuffer buffer = new Int8List.fromList(newVal).buffer;
      ByteData byteData = new ByteData.view(buffer);
      roll = byteData.getFloat32(0,Endian.little);
      rtext = "Base64: $value";
      rtext_1 = "Back to float: $roll";
      ptext = "Value is ${buttVal != null ? buttVal : ""}";
    });
  }

  _actionY(String value) {
    final List<int> newVal = base64.decode(value);
    setState(() {
      //buttVal = newVal[0];
      ByteBuffer buffer = new Int8List.fromList(newVal).buffer;
      ByteData byteData = new ByteData.view(buffer);
      accY = byteData.getFloat32(0,Endian.little);
      //rtext = "Base64: $value";
     // rtext_1 = "Back to float: $roll";
     // ptext = "Value is ${buttVal != null ? buttVal : ""}";
    });
  }


_incrementCounter(int val){
//    if(val == 1){
//      setState((){
//        _value++;
//        _counter++;
//      });
//    }
//    else {
      setState(() {
        if(_counter == 360){
          _counter=0;}
       _counter= _counter+90;
      });
    //}
  }

}

class ChartData {
  final int barTime;
  //final String barValue;
  final double timeStep;
  //final int buttonVal;

  final charts.Color color;

  ChartData(this.barTime, this.timeStep, Color color)
  : this.color = new charts.Color(
    r: color.red, g: color.green, b: color.blue, a: color.alpha);

}

class BarData {
  final String axis;
  final double data_b;

  BarData(this.axis, this.data_b);

}