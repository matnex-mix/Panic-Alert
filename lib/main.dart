import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panic Alert',
      theme: ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Loading();
  }

  Future<Timer> Loading() async {
    return Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    if( !Models.internetConnected() ) {
      Models.navigateReplace(context, 'notconnected');
    } else if( !Models.loggedIn() ) {
      Models.navigateReplace(context, 'login');
    } else {
      Models.navigateReplace(context, 'home');
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/panic_alert.png', height: 100.0,),
              SizedBox(height: 30.0,),
              Text(
                'Panic Alert',
                style: TextStyle(fontSize: 30.0, color: Colors.pink),
              ),
              Text(
                '...no panics,  just radix',
                style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).primaryColor, fontSize: 20.0),
              )
            ],
          ),
        )
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}