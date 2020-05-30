import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => new _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          elevation: 3.0,
          title: Text( 'About' ),
          leading: IconButton(
              icon: new Icon( Icons.arrow_back ),
              onPressed: (){
                Navigator.pop( context );
              }
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  'Panic Alert (r)',
                  style: TextStyle( fontSize: 20.0, color: Colors.white ),
                ),
              ),
              SizedBox(height: 5.0,),
              Center(
                child: Text(
                  'by Petabytechnology, RC: 23159002',
                  style: TextStyle( fontSize: 18.0, fontStyle: FontStyle.italic , color: Colors.white ),
                )
              ),
              SizedBox(height: 15.0),
              Center(
                child: Text(
                  'https://www.petabytechnology.com',
                  style: TextStyle( fontSize: 16.0, color: Colors.blue, decoration: TextDecoration.underline ),
                ),
              ),
              SizedBox(height: 5.0,),
              Center(
                child: Text(
                  'info@petabytechnology.com',
                  style: TextStyle( fontSize: 16.0, color: Colors.blue ),
                ),
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Text(
                  'Panic Alert is a quick alert system that notifies friends, family & samaritans of your current situation incase of panics. We\'re aimed at solving panic issues not totally but to our possible best.',
                  style: TextStyle( fontSize: 16.0, color: Colors.white ),
                ),
              ),
              SizedBox(height: 20.0,),
              Center(
                child: Text(
                  '(c) 2019',
                  style: TextStyle( fontSize: 20.0, color: Colors.white ),
                ),
              ),
              SizedBox(height: 5.0,),
              Center(
                child: Text(
                  '...no panics with radix',
                  style: TextStyle( fontSize: 17.0, color: Colors.white, fontStyle: FontStyle.italic ),
                ),
              ),
              SizedBox(height: 40.0,),
              Center(
                child: Text(
                  'Developers',
                  style: TextStyle( fontSize: 25.0, color: Colors.white, decoration: TextDecoration.underline ),
                ),
              ),
              SizedBox(height: 18.0,),
              Center(
                child: Text(
                  "Jolaosho Abdulmateen\nOkesola Taofeeq\nDiyaolu Abdulmalik\nOyero Habib\nMr. Khalil Balogun",
                  style: TextStyle( fontSize: 18.0, color: Colors.blueGrey ),
                ),
              )
            ]
          )
        )
      ),
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
    );
  }
}