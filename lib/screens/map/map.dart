import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:odyssee/models/line.dart';
import 'package:odyssee/data/trails.dart';
import 'package:odyssee/screens/classification/classification.dart';
import 'package:odyssee/shared/header_nav.dart';

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.8662, -119.5422);
  final Set<Polyline>_polyline = {};
  String _trailName = 'Cooks Meadow Loop';
  List<LatLng> polylinePoints = List();

  Icon locationIcon = Icon(Icons.directions_walk);
  Icon sourceIcon = Icon(Icons.trip_origin);
  Icon destinationIcon = Icon(Icons.flag);

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  void _onMapCreated(GoogleMapController controller) {

//    polylinePoints = Line(_trailName).points();

//    setState(() {
//      mapController = controller;
//
//      _polyline.add(Polyline(
//              polylineId: PolylineId('line1'),
//              visible: true,
//              points: polylinePoints,
//              width: 5,
//              color: Colors.blue,
//          ));
//    });

    // pan to the new position of the trail
    CameraPosition cPosition = CameraPosition(
      zoom: 16.0,
      target: polylinePoints[0],
      );

      mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }
  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
    });
    // set the initial location
    setInitialLocation();

    CameraPosition cPosition = CameraPosition(
      zoom: 16.0,
      target: polylinePoints[0],
    );

    mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
  }

  void _onChangeTrail(String trailName, GoogleMapController controller){
    
    print('Updating the trail');
    
    setState(() {
      _trailName = trailName;
      print('New trailname $_trailName');

      polylinePoints = Line(_trailName).points();
      mapController = controller;

      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        points: polylinePoints,
        width: 5,
        color: Colors.blue,
      ));  

    }); 
    
     // pan to the new position of the trail
     CameraPosition cPosition = CameraPosition(
      zoom: 16.0,
      target: polylinePoints[0],
      );

      mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  @override
  Widget build(BuildContext context) {
    print('PolyLine');
    print(_polyline);
    print(_trailName);

    return MaterialApp(
      home: Scaffold(
        appBar: BaseAppBar(
          title: Text('Trail Map'),
          appBar: AppBar(),
        ),
        drawer: BaseDrawer(),
        body: GoogleMap(
          polylines: _polyline,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: polylinePoints.isEmpty ? _center : polylinePoints[0],
            zoom: polylinePoints.isEmpty ? 11.0 : 18.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PopupMenuButton(
                  offset: Offset(100, 100),
                  icon: Icon(Icons.map),
                  initialValue: 'Select a Trail',
                  onSelected: (val) { _onChangeTrail(val, mapController);} ,
                  itemBuilder: (context) => TrailData.trailMap.keys.map((trail) =>
                    PopupMenuItem(
                      value: trail,
                      child: Text(trail)
                      )
                  ).toList(),
                ),
                FloatingActionButton(
                  elevation: 5.0,
                  foregroundColor: Color(0xFFE5D9A5),
                  backgroundColor: Color(0xEF194000),
                  child: new Icon(Icons.camera_alt, size: 45.0,),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClassifyImage())),
                ),
                PopupMenuButton<int>(
                  offset: Offset(100, 100),
                  icon: Icon(Icons.art_track),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Flutter Open",
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        "Flutter Tutorial",
                      ),
                    ),
                  ],
                ),
//                FloatingActionButton(
//                  elevation: 5.0,
//                  foregroundColor: Color(0xFFE5D9A5),
//                  backgroundColor: Color(0xEF194000),
//                  mini: true,
//                  child: new Icon(Icons.art_track, size: 25.0,),
//                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClassifyImage())),
//              ],
//            ),
//      ),
//      ),
//          FloatingActionButton(
//            elevation: 5.0,
//            foregroundColor: Color(0xFFE5D9A5),
//            backgroundColor: Color(0xEF194000),
//            child: new Icon(Icons.camera_alt, size: 45.0,),
//            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClassifyImage())),
//          ),
              ]
      ),
    )
    )
    );
  }
}
