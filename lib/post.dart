import 'dart:io';

import 'package:flutter/material.dart';
import 'package:panic_alert/widget.dart';
import 'package:panic_alert/models.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => new _PostState();
}

class _PostState extends State<Post> {
  var Snapshots = [];
  String content = '';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.white,
          title: Text( 'New Panic', style: TextStyle(color: Colors.blue), ),
          leading: IconButton(
              icon: new Icon( Icons.arrow_back, color: Colors.blue, ),
              onPressed: (){
                Navigator.pop( context );
              }
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            Container(
              height: 200,
              margin: EdgeInsets.only(top: 10.0),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Optional content',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                expands: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 2000,
                onChanged: (value){
                  setState(() {
                    content = value;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(children: <Widget>[
                Text(
                  'panic in ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(
                  Models.post['title'],
                  style: TextStyle(color: Colors.blue),
                ),
                Expanded(
                  child: Container(),
                ),
                Text('[ ${content.length}/2000 ]'),
              ],)
            ),
            Container(
              height: 140.0,
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: .8, color: Color(0xFFB2B2B2)), bottom: BorderSide(width: .8, color: Color(0xFFB2B2B2))),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Snapshots.length+1,
                itemBuilder: (BuildContext context, int index){
                  if( index== 0 ) {
                    return InkWell(
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Icon( Icons.add_a_photo, color: Colors.blue, size: 40.0, ),
                      ),
                      onTap: () async {
                        if( Snapshots.length <= 5 ) {
                          var path = await CameraWidget(context);
                          var size = File(File(path).resolveSymbolicLinksSync()).lengthSync();
                          if( Snapshots.contains(path) ) {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text('Snapshot already selected'),
                                );
                              },
                            );
                          } else if( size > (2*1024*1024) ) {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Text('Image size too much'),
                                );
                              },
                            );
                          } else {
                            setState((){
                              Snapshots.add(path);
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                content: Text('Maximum number of snapshots reached'),
                              );
                            },
                          );
                        }
                      },
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: Dismissible(
                        key: Key((index-1).toString()),
                        direction: DismissDirection.down,
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(15.0),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            child: FittedBox(
                              child: Image.file( new File(Snapshots[index-1]) ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onDismissed: (dir){
                          setState(() {
                            Snapshots.removeAt(index-1);
                          });
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              onPressed: () async {
                String arts = await Models.postFile( '&api=addArts', Snapshots );
                if( arts!='' ) {
                  showDialog (
                    context: context,
                    builder: (BuildContext context ) {
                      return AlertDialog(
                        content: FutureBuilder<EndPoint>(
                          future: Models.fetchData('&api=addPanic&arts='+arts+'&content='+content+'&category='+Models.post['id']),
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
                                  'Panic added successfully',
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
                  }).then((val){
                    Navigator.pop(context);
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text(
                          'an error ocurred',
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18.0),
                        ),
                      );
                    }
                  );
                }
              },
              child: Text('SPREAD PANIC'),
            ),
          ],
        )
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}