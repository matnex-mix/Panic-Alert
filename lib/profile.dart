import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';
import 'package:panic_alert/widget.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nicename = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController bvn = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController kins_nicename = TextEditingController();
  final TextEditingController kins_phone = TextEditingController();
  final TextEditingController kins_address = TextEditingController();
  final TextEditingController oldpass = TextEditingController();
  final TextEditingController newpass = TextEditingController();
  String username = 'Profile';
  String kins_type;
  String art;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon( Icons.arrow_back, color: Colors.blue, ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text( username, style: TextStyle( color: Colors.blue ), ),
        ),
        body: FutureBuilder<EndPoint>(
          future: Models.fetchData('&api=getUser'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if( snapshot.data.error > 0 ) {
                return Text(snapshot.data.errors[0]['error']);
              } else {
                snapshot.data.data.remove('dummy');
                var data = snapshot.data.data;

                // ----------------------------------------------------------
                // SET ALL NECESSARY DATA

                nicename.text = data['nicename'];
                phone.text = data['phone'];
                email.text = data['email'];
                bvn.text = data['bvn'];
                address.text = data['address'];
                kins_nicename.text = data['kins_nicename'];
                kins_phone.text = data['kins_phone'];
                kins_address.text = data['kins_address'];
                if( kins_type==null )
                  kins_type = data['kins_type'];
                if( kins_type=='' )
                  kins_type = 'KIN\'S RELATIONSHIP';
                username = '@'+data['username'];
                
                // ----------------------------------------------------------
                
                return ListView(
                    padding: EdgeInsets.all(10.0),
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 300,
                        color: Colors.blue,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: InkWell(
                          child: Container(
                            height: 160,
                            width: 160,
                            child: FittedBox(
                              child: Image.network(
                                '${Models.apiLink}/arts/'+ (art==null ? (data['art']!='' ? data['art'] : 'default.jpeg') : art),
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          onTap: () async{
                            var path = await CameraWidget(context);
                            var size = File(File(path).resolveSymbolicLinksSync()).lengthSync();
                            if( size > (2*1024*1024) ) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    content: Text('Image size too much'),
                                  );
                                },
                              );
                            } else {
                              String arts = await Models.postFile( '&api=addArts', [path] );
                              setState(() {
                                art = arts;
                              });
                              showDialog (
                                context: context,
                                builder: (BuildContext context ) {
                                  return AlertDialog(
                                    content: FutureBuilder<EndPoint>(
                                      future: Models.fetchData('&api=setUser&art='+art),
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
                                              'Change successfull',
                                              style: TextStyle(

                                              ),
                                            );
                                          }
                                        }

                                        return LinearProgressIndicator();
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      TextField(
                        controller: nicename,
                        decoration: InputDecoration(
                          labelText: 'Nice Name'
                        ),
                      ),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: 'Email'
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: phone,
                        decoration: InputDecoration(
                          labelText: 'Telephone'
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: bvn,
                        decoration: InputDecoration(
                          labelText: 'BVN'
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState((){
                            bvn.text = value.substring(0,value.length-1);
                          });
                        },
                      ),
                      TextField(
                        controller: address,
                        decoration: InputDecoration(
                          labelText: 'Address'
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                      SizedBox(height: 15.0,),
                      RaisedButton(
                        child: Text(
                          'DONE'
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          showDialog (
                            context: context,
                            builder: (BuildContext context ) {
                              return AlertDialog(
                                content: FutureBuilder<EndPoint>(
                                  future: Models.fetchData('&api=setUser&nicename='+nicename.text+'&phone='+phone.text+'&email='+email.text+'&address='+address.text),
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
                                          'Change successfull',
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
                          );
                        },
                      ),

                      // NEXT OF KIN'S INFORMATION

                      Container(
                        height: .8,
                        margin: EdgeInsets.only(top: 30.0,bottom: 30.0),
                        color: Color(0xFFA7A7A7),
                      ),
                      Text(
                        'Next Of Kin',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: kins_nicename,
                        decoration: InputDecoration(
                          labelText: 'Nice Name'
                        ),
                      ),
                      TextField(
                        controller: kins_phone,
                        decoration: InputDecoration(
                          labelText: 'Telephone'
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: kins_address,
                        decoration: InputDecoration(
                          labelText: 'Address'
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                      Container(
                        height: 60.0,
                        margin: EdgeInsets.only(top: 15.0),
                        child: new DropdownButton<String>(
                          items: <String>[
                            'KIN\'S RELATIONSHIP',
                            'MOTHER',
                            'FATHER',
                            'SISTER',
                            'BROTHER',
                            'COUSIN',
                            'MOTHER-INLAW',
                            'FATHER-INLAW',
                            'BROTHER-INLAW',
                            'SISTHER-INLAW',
                          ].map((String value){
                            return DropdownMenuItem(
                              value: value,
                              child: Container(
                                color: kins_type==value ? Colors.grey : null,
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (value){
                            if( value!='KIN\'S RELATIONSHIP' ){
                              setState(() {
                                kins_type = value;
                              });
                            }
                          },
                          value: kins_type,
                          isExpanded: true,
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      RaisedButton(
                        child: Text(
                          'DONE'
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          showDialog (
                            context: context,
                            builder: (BuildContext context ) {
                              return AlertDialog(
                                content: FutureBuilder<EndPoint>(
                                  future: Models.fetchData('&api=setUser&kins_nicename='+kins_nicename.text+'&kins_phone='+kins_phone.text+'&kins_address='+kins_address.text+'&kins_type='+kins_type),
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
                                          'Change successfull',
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
                          );
                        },
                      ),

                      // CHANGE PASSWORD

                      Container(
                        height: .8,
                        margin: EdgeInsets.only(top: 30.0,bottom: 30.0),
                        color: Color(0xFFA7A7A7),
                      ),
                      Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: oldpass,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                        ),
                        obscureText: true,
                      ),
                      TextField(
                        controller: newpass,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                        ),
                        obscureText: true,
                      ),
                      SizedBox( height: 15.0, ),
                      RaisedButton(
                        child: Text(
                          'DONE'
                        ),
                        color: Colors.blue,
                        onPressed: (){
                          showDialog (
                            context: context,
                            builder: (BuildContext context ) {
                              if( Models.md5(data['username']+'&${oldpass.text}') != data['key'] ) {
                                return AlertDialog(
                                  content: Text(
                                    'Incorrect old password'
                                  ),
                                );
                              }
                              return AlertDialog(
                                content: FutureBuilder<EndPoint>(
                                  future: Models.fetchData('&api=setUser&password='+newpass.text),
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
                                          'Change successfull',
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
                          );
                        },
                      ),
                    ],
                  );
                }
            } else if (snapshot.hasError) {
              return Text(
                '${snapshot.error}',
                style: TextStyle(

                ),
              );
              // Navigator.pushReplacementNamed(context, '/notconnected');
            }

            return SizedBox(
              height: 10.0,
              child: LinearProgressIndicator(),
            );
          },
        ),
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}