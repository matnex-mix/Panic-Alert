import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController password = new TextEditingController();
  TextEditingController username = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Sign-In',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                    height: 40.0,
                    child: TextField(
                      controller: username,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Username',
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 40.0,
                    child: TextField(
                      controller: password,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Password',
                        filled: true,
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 40.0,),
                  RaisedButton (
                    color: Colors.white,
                    child: Container(
                      alignment: Alignment.center,
                      width: 100.0,
                      child: Text('LOGIN', style: TextStyle(color: Theme.of(context).primaryColor),),
                    ),
                    onPressed: (){
                      showDialog (
                        context: context,
                        builder: (BuildContext context ) {
                          return AlertDialog(
                            content: FutureBuilder<EndPoint>(
                              future: Models.fetchData('&api=login&username='+username.text+'&password='+password.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if( snapshot.data.data['auth']==1 ) {
                                    Models.session['timestamp'] = new DateTime.now().millisecondsSinceEpoch.toString();
                                    Models.session['auth_id'] = snapshot.data.data['auth_id'];
                                    return Text(
                                      'Logged in successfully',
                                      style: TextStyle(

                                      ),
                                    );
                                  } else if( snapshot.data.error > 0 ) {
                                    return Text(
                                      snapshot.data.errors[0]['error'],
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
                  SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            'forgot password',
                            style: TextStyle(color: Colors.blue, fontSize: 15.0),
                          ),
                          onPressed: (){
                            Models.navigate(context, 'forgot_password');
                          },
                        ),
                      ),
                      Text(
                        '  |  ',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      Container(
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            'create account',
                            style: TextStyle(color: Colors.blue, fontSize: 15.0),
                          ),
                          onPressed: (){
                            Models.navigate(context, 'sign_in');
                          },
                        ),
                      ),
                    ]
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    'by signing in, your\'re agreeing to our terms and policies of service.',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
                  )
                ],
              ),
            ),
          )
        ),
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}