import 'package:flutter/material.dart';
import 'package:panic_alert/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bIndex = 0;
  var expanded = [true,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title, style: TextStyle(color: Colors.blue)),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.info, color: Colors.blue),
            onPressed: (){
              Models.navigate(context, 'about');
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        shrinkWrap: true,
        children: <Widget>[

          // Emergency Panic Cases
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFB7B7B7), width: .9),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Emergency Panics', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )),
                IconButton(
                  icon: Icon( expanded[0]==true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 25.0, ),
                  onPressed: (){
                    setState(() {
                      expanded[0] = !expanded[0];
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: expanded[0]==true ? null : 0,
            child: Panics( context, 0 ),
          ),

          // Other Panic Cases
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFB7B7B7), width: .9),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Other Panics', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
                )),
                IconButton(
                  icon: Icon( expanded[1]==true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 25.0, ),
                  onPressed: (){
                    setState(() {
                      expanded[1] = !expanded[1];
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            height: expanded[1]==true ? null : 0,
            child: Panics( context, 1 ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bIndex,
        selectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.powerOff, color: Colors.blue ),
            title: Text('', style: TextStyle(color: Colors.blue))
          ),
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.userEdit, color: Colors.blue ),
            title: Text('', style: TextStyle(color: Colors.blue))
          ),
          BottomNavigationBarItem(
            icon: Icon( FontAwesomeIcons.podcast, color: Colors.blue ),
            title: Text('', style: TextStyle(color: Colors.blue))
          ),
        ],
        onTap: (index){
          if( index==1 ) {
            Models.navigate(context, 'profile');
          } else if( index==2 ) {
            Models.navigate(context, 'panics');
          } else {
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: FutureBuilder<EndPoint>(
                    future: Models.fetchData('&api=logout'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if( snapshot.data.error > 0 ) {
                          return Text(
                            snapshot.data.errors[0]['error'],
                            style: TextStyle(

                            ),
                          );
                        } else {
                          Navigator.pop(context, 1);
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
              if( val==1 ){
                Models.navigateReplace(context, 'login');
                Models.session['timestamp'] = '';
                Models.session['auth_id'] = '';
              }
            });
          }
        },
      ),
    );
  }

  Widget Panics( context, type ) {
    return FutureBuilder<EndPoint>(
      future: Models.fetchData('&api=getCategory&type=$type'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var children = <Widget>[];
          if( snapshot.data.error > 0 ) {
            children.add(Text(
              snapshot.data.errors[0].error
            ));
          } else {
            snapshot.data.data.remove('dummy');
            for( int index=0;index<snapshot.data.data.length;index++ ){
              var data = snapshot.data.data[index.toString()];
              children.add(
                Row(children:<Widget>[Expanded(child: FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: (){
                    setState(() {
                      Models.post['id'] = data['id'];
                      Models.post['title'] = data['title'];
                      Models.navigate(context, 'post');
                    });
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(data['title'].toUpperCase(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)),
                  )
                ) )],)
              );
            }
          }
          
          return Column(
            children: children,
          );

        } else if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(

            ),
          );
        }

        return SizedBox(
          height: 10.0,
          child: LinearProgressIndicator(),
        );
      },
    );
  }
}