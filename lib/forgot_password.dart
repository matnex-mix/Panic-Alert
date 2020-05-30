import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => new _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';

  @override
  Widget build(BuildContext context) {
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
                    child: Text( 'Forgot Password', style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    height: 45.0,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder()
                      ),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                    )
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    child: Text('MAIL ME'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      
                      showDialog (
                        context: context,
                        builder: (BuildContext context ) {
                          return AlertDialog(
                            content: FutureBuilder<EndPoint>(
                              future: Models.fetchData('&api=forgotPassword&email='+email),
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
                                      'An email containing your details has been sent, do check to recover your password',
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
                    },
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    alignment: Alignment.center,
                    child: Text( 'you\'ll receive an email with a recovery link, click it to recover or change your password', style: TextStyle(
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
}