import 'package:flutter/material.dart';

class NotConnected extends StatefulWidget {
  @override
  _NotConnectedState createState() => new _NotConnectedState();
}

class _NotConnectedState extends State<NotConnected> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left:20.0, right: 20.0, top: 50.0, bottom: 50.0),
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: ListView(
            children: <Widget>[
              Container(
                child: Icon( Icons.wifi_lock, size: 60.0, ),
              ),
              SizedBox(height: 30.0,),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '404',
                  style: TextStyle(fontSize: 60.0, fontFamily: 'Tahoma', color: Theme.of(context).primaryColor)
                )
              ),
              SizedBox(height: 30.0,),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'INTERNET NOT CONNECTED',
                  style: TextStyle(fontSize: 35.0, fontFamily: 'Tahoma', color: Theme.of(context).primaryColor)
                )
              ),
            ],
          )
        ),
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}