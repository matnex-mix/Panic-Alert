import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panic_alert/models.dart';
import 'package:geolocator/geolocator.dart';

class Locate extends StatefulWidget {
  @override
  _LocateState createState() => new _LocateState();
}

class _LocateState extends State<Locate> {

    Geolocator _geolocator;
    static Position _position = Position(
      longitude: 3.3645147,
      latitude: 7.1344993,
    );
    static CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(_position.latitude, _position.longitude),
      zoom: 16
    );
    Map<String, Marker> markers = <String, Marker>{
      'initial': Marker(
        markerId: MarkerId('petabyte'),
        position: LatLng(_position.latitude, _position.longitude),
        infoWindow: InfoWindow(
          title: 'Petabyte Technology',
          snippet: '4 Oyerogbo Street, Opposite Ewang Junction Abiola-Way.',
        ),
      ),
      'dest': Marker(
        markerId: MarkerId('dest'),
        position: LatLng(7.1797129, 3.4053326),
        infoWindow: InfoWindow(
          title: 'Destination Position',
          snippet: '',
        ),
      ),
    };
    Set<Polyline> _polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    void setPolylines() async {
      List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        'AIzaSyArrm4Dqt2ekkl2EyC2FTqh_WxTAjkFgG0',
        _position.latitude, 
        _position.longitude,
        7.1797129,
        3.4053326
      );
        print('*****************************************************');
        print(result);
        print('*****************************************************');
      if(result.isNotEmpty){
        polylineCoordinates.clear();
        result.forEach((PointLatLng point){
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        _polylines.clear();
      }
      setState(() {
        Polyline polyline = Polyline(
          polylineId: PolylineId('poly'+Random.secure().nextInt(20000000).toString()),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates
        );
        _polylines.add(polyline); 
      });
    }

    void checkEnability( context ) async {
      var status = await _geolocator.checkGeolocationPermissionStatus();
      if (status != GeolocationStatus.granted) {
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text( 'some part of this application requires you to turn on your location for proper functioning.' ),
              actions: <Widget>[
                FlatButton(
                  child: Text( 'OK' ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        );
      }
    }

    @override
    void initState() {
      super.initState();

      _geolocator = Geolocator();
      LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

      updateLocation();
      setPolylines();

      StreamSubscription positionStream = _geolocator.getPositionStream(locationOptions).listen(
          (Position position) async {
        _position = position;
        String _currentAddress = '';
        try {
          List<Placemark> p = await _geolocator.placemarkFromCoordinates(_position.latitude, _position.longitude);
          Placemark place = p[0];
          _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
        } catch (e) {}
        Marker marker = Marker(
          markerId: MarkerId('My Location'),
          position: LatLng(_position.latitude, _position.longitude),
          infoWindow: InfoWindow(
            title: 'My Location',
            snippet: _currentAddress,
          ),
        );
        setState(() {
          markers['initial'] = marker;
          _initialCameraPosition = CameraPosition(
            target: LatLng(_position.latitude, _position.longitude),
            zoom: 16
          );
        });
        //setPolylines();
      });
    }

    void updateLocation() async {
      try {
        Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .timeout(new Duration(seconds: 5));

        setState(() {
          _position = newPosition;
        });
      } catch (e) {
      }
    }

  @override
  Widget build(BuildContext context) {

    checkEnability( context );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.redAccent,
                  ),
                  /*child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _initialCameraPosition,
                      markers: Set<Marker>.of(markers.values),
                      polylines: _polylines,
                  ),*/
                )
              ],
            ),
            Column(
              children: <Widget>[
                AppBar(
                  elevation: 0,
                  backgroundColor: Color(0x30000000),
                  leading: IconButton(
                    icon: Icon( Icons.arrow_back ),
                    color: Colors.white,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}