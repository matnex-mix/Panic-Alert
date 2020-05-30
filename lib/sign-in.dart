import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  String username = '';
  String password = '';
  String bvn = '';
  DateTime dob;

  @override
  Widget build(BuildContext context){
    if(password==''){
      password = base64Url.encode(List.generate(6, (i) => Random.secure().nextInt(256)));
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon( Icons.arrow_back ),
            color: Colors.blue,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text( 'Sign Up', style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    height: 60.0,
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder()
                            ),
                            maxLength: 12,
                            onChanged: (val){
                              setState(() {
                                username = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20.0,),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                              text: password
                            ),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              counterText: 'generated...'
                            ),
                            enabled: false,
                            onChanged: (val){
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.0,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'BVN',
                        border: OutlineInputBorder()
                      ),
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          bvn = val;
                        });
                      },
                    )
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    child: Text('SIGN UP'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      doDateConfirm(context);
                    },
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    alignment: Alignment.center,
                    child: Text( 'by signing up, you agree to follow the panic alert\'s terms and policies', style: TextStyle(
                      fontSize: 13.0
                    ), ),
                  ),
                  SizedBox(height: 40.0,),
                  Container(
                    alignment: Alignment.center,
                    child: Text( '(c) Petabyte Technology 2019', style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void doDateConfirm( context ){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          backgroundColor: Colors.pink,
          content: Container(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Text( 'please select the date-of-birth associated with your BVN in the next screen', style: TextStyle(
              color: Colors.white
            ), ),
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.black,
              child: Text( 'OK' ),
              onPressed: (){
                Navigator.pop(context, 1);
              },
            )
          ],
        );
      }
    ).then((val){
      if( val==1 ){
        showDatePicker(
          context: context,
          initialDate: DateTime(2002),
          firstDate: DateTime(1940),
          lastDate: DateTime(DateTime.now().year),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark(),
              child: child,
            );
          },
        ).then((val){
          if( val!=null ){
            dob = val;
            doProcessing(context);
          }
        });
      }
    });
  }

  void doProcessing( context ){
    showDialog (
      context: context,
      builder: (BuildContext context ) {
        return AlertDialog(
          content: FutureBuilder<EndPoint>(
            future: Models.fetchData('&api=addUser&bvn=$bvn&username=$username&password=$password&date=${dob.toString().substring(0, 11).trim()}'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if( snapshot.data.error > 0 ) {
                  return Text(
                    snapshot.data.errors[0]['error'],
                    style: TextStyle(

                    ),
                  );
                } else {
                  return Text(
                    'account created successfully, you can now login',
                    style: TextStyle(

                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(

                  ),
                );
              }

              // By default, show a loading spinner.
              return SizedBox(
                height: 10.0,
                child: LinearProgressIndicator(),
              );
            },
          ),
        );
      }
    ).then((val){
      if( Models.loggedIn() ) {
        Models.navigateReplace(context, 'home');
      }
    });
  }
}