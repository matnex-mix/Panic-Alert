import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';

class Panics extends StatefulWidget {
  @override
  _PanicsState createState() => new _PanicsState();
}
  
class _PanicsState extends State<Panics> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 3.0,
          backgroundColor: Colors.white,
          title: Text( 'Panics', style: TextStyle( color: Colors.blue, )),
          leading: IconButton(
              icon: new Icon( Icons.arrow_back, color: Colors.blue, ),
              onPressed: (){
                Navigator.pop( context );
              }
          ),
        ),
        body: FutureBuilder<EndPoint>(
          future: Models.fetchData('&api=getPanics'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if( snapshot.data.error > 0 ) {
                return Text(snapshot.data.errors[0].error);
              } else {
                snapshot.data.data.remove('dummy');
                return ListView(
                  // padding: EdgeInsets.all(10.0),
                  children: List.generate(snapshot.data.data.length, (int index){
                    var data = snapshot.data.data[index.toString()];
                    return Card(
                      elevation: 2.0,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            Models.postState(int.parse(data['id']));
                            Models.navigate( context, 'panic' );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFA7A7A7), width: .8)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        (data['category']+' PANIC').toUpperCase(),
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Icon( Icons.location_on, size: 18.0, color: Colors.blue,),
                                    Text(
                                      '20m',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '@'+data['user']
                                    ),
                                  ),
                                  Icon( Icons.timer, size: 18, color: Colors.blue, ),
                                  SizedBox(width: 5.0,),
                                  Text(
                                    data['time'],
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                      ),
                    );
                  }),
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

            // By default, show a loading spinner.
            return SizedBox(
              height: 10.0,
              child: LinearProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}