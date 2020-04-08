import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odyssee/models/line.dart';
import 'package:odyssee/data/trails.dart';

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.8662, -119.5422);
  final Set<Polyline>_polyline={};
  String _trailName = 'Cooks Meadow Loop';
  List<LatLng> polylinePoints = List();

  void _onMapCreated(GoogleMapController controller) {

    polylinePoints = Line(_trailName).points();

    setState(() {
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
        appBar: AppBar(
          title: Text('Yosemite Trail'),
          backgroundColor: Colors.green[700],
        ),
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
              ]
      ),
    )
    )
    );
  }
}
