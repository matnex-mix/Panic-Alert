import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

class SinglePanic extends StatefulWidget {
  @override
  _SinglePanicState createState() => new _SinglePanicState();
}

class _SinglePanicState extends State<SinglePanic> {
  int showDelete = 0;
  bool panicRemoved = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.white,
          title: Text( 'Single Panic', style: TextStyle( color: Theme.of(context).primaryColor, )),
          leading: IconButton(
            icon: new Icon( Icons.arrow_back, color: Theme.of(context).primaryColor, ),
            onPressed: (){
              Navigator.pop( context );
            }
          ),
          actions: <Widget>[
            Container(
              child: showDelete == 1 ? IconButton(
                icon: Icon( Icons.delete, color: Colors.blue, ),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        content: Text('Are you sure you want to delete this panic'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('CANCEL'),
                            onPressed: (){
                              Navigator.pop(context, 0);
                            },
                          ),
                          FlatButton(
                            child: Text('OK'),
                            onPressed: (){
                              Navigator.pop(context, 1);
                            },
                          )
                        ],
                      );
                    },
                  ).then((val){
                    if( val==1 ){
                      deletePanic(context, Models.index.toString());
                    }
                  });
                },
                tooltip: 'delete this panic',
              ) :
              IconButton(
                icon: Icon( Icons.report, color: Colors.blue, ),
                onPressed: (){
                  reportPanic(context, Models.index.toString());
                },
                tooltip: 'report false alarm',
              ),
            ),
          ],
        ),
        body: FutureBuilder<EndPoint>(
          future: Models.fetchData('&api=getSinglePanic&panic='+Models.index.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if( snapshot.data.error > 0 ) {
                return Text(snapshot.data.errors[0]['error']);
              } else {
                snapshot.data.data.remove('dummy');
                var data = snapshot.data.data;
                if( int.parse(data['mine'])==1 ){
                  showDelete = 1;
                } else {
                  showDelete = 0;
                }
                var quickInterval;
                quickInterval = (){
                  if( this.mounted ) {
                    setState(() {
                      showDelete = showDelete;
                    });
                  } else {
                    if( quickInterval != null ) { 
                      Future.delayed(Duration(milliseconds: 200), quickInterval);
                    }
                  }
                };

                Future.delayed(Duration(milliseconds: 200), quickInterval);

                return ListView(
                  padding: EdgeInsets.all(20.0),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Container(
                            height: 64,
                            width: 64,
                            child: FittedBox(
                              child: Image.network(
                                '${Models.apiLink}/arts/'+data['user_art']
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['user_name'],
                              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@'+data['user'],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: .8,
                      margin: EdgeInsets.only(top: 20.0,bottom: 20.0),
                      color: Color(0xFFA7A7A7),
                    ),
                    Text(
                      data['content'],
                      style: TextStyle(
                        fontSize: 21.0,
                        // color: Colors.white
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      height: 270.0,
                      child: PageView(
                        children: List.generate(data['arts'].length, (int index){
                          return Container(
                            child: FittedBox(
                              child: Image.network('${Models.apiLink}/arts/'+data['arts'][index]),
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      height: .8,
                      margin: EdgeInsets.only(top: 20.0,bottom: 20.0),
                      color: Color(0xFFC2C2C2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          data['time'],
                          style: TextStyle(fontStyle: FontStyle.italic,fontSize: 17.0),
                        ),
                        SizedBox(width: 10.0,),
                        Expanded(
                          child: Text(
                            data['category'].toUpperCase(),
                            style: TextStyle(color: Colors.blue,fontSize: 17.0,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0,),
                    RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_searching),
                          SizedBox(width: 15.0,),
                          Text(
                            'BEAM LOCATION'
                          ),
                        ],
                      ),
                      onPressed: (){
                        //beamLocation(context);
                        Models.navigate(context, 'locate');
                      },
                    )
                  ]
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
    );
  }

  void deletePanic( context, index ) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: FutureBuilder<EndPoint>(
            future: Models.fetchData('&api=setPanic&panic=$index&state=0'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if( snapshot.data.error > 0 ) {
                  return Text(
                    snapshot.data.errors[0]['error'],
                    style: TextStyle(

                    ),
                  );
                } else {
                  panicRemoved=true;
                  return Text(
                    'deleted successfully',
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
      if( panicRemoved==true ) {
        Navigator.pop(context);
      }
    });
  }

  void reportPanic( context, index ) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: FutureBuilder<EndPoint>(
            future: Models.fetchData('&api=addReport&panic=$index'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if( snapshot.data.error > 0 ) {
                  return Text(
                    snapshot.data.errors[0]['error'],
                    style: TextStyle(

                    ),
                  );
                } else {
                  panicRemoved=true;
                  return Text(
                    'thanks for your report, we\'ll attend to it amiably',
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
  }

  void beamLocation( context ) {
    showDialog(
      context: context,
      builder: (context){
        return Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            Container(
              height: 320,
              padding: EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(30, 23, 250, .5),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text('4.5M', style: TextStyle(color: Colors.blue, fontSize: 25.0),),
                        SizedBox(height: 10.0,),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text('USE MAP'),
                          onPressed: (){
                            // LOAD GOOGLE MAPS
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}