import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odyssee/screens/start/start_menu.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:odyssee/screens/achievements/achievements.dart';
import 'package:odyssee/screens/authenticate/authenticate.dart';
import 'package:odyssee/screens/social/feed.dart';
import 'package:odyssee/screens/classification/classification.dart';
import 'package:odyssee/models/line.dart';
import 'package:odyssee/data/trails.dart';

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(37.8662, -119.5422);

  Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  String _trailName = 'Cooks Meadow Loop';
  List<LatLng> polylinePoints = List();

  Icon locationIcon = Icon(Icons.directions_walk);
  Icon sourceIcon = Icon(Icons.trip_origin);
  Icon destinationIcon = Icon(Icons.flag);

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

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
      home: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () { Scaffold.of(context).openDrawer(); },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            backgroundColor: Color(0xFF194000),
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Color(0xFFE86935),
            ),
          ),
          drawer: Drawer(
            elevation: 15.0,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text("Placeholder name",
                    style: TextStyle(
                      color: Color(0xFFE5D9A5),
                      fontSize: 25,
                    ),
                  ),
                  accountEmail: Text("Placeholder email.com"),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/drawer_background.jpg"), fit: BoxFit.cover)
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color(0xFFE5D9A5),
//                    child: Text(
//                      'Account Placeholder',
//                      style: TextStyle(
//                        color: Color(0xFFE5D9A5),
//                        fontSize: 30,
//                      ),
//                    ),
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.account_circle,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Account',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.group,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Social',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Feed()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.flag,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Achievements',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Achievements()),
                      );
                    },
                  ),
                ),
                Container(
                  child: ListTile(
                    leading: Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Color(0xFFE86935)
                    ),
                    title: Text('Back to Main Menu',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE86935)
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StartMenu()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: GoogleMap(
	    polylines: _polyline,
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: polylinePoints.isEmpty ? _center : polylinePoints[0],
              zoom: polylinePoints.isEmpty ? 11.0 : 18.0,
            ),
//            minMaxZoomPreference: new MinMaxZoomPreference(1, 11),
            cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
                northeast: LatLng(38.187466, -119.201724),
                southwest: LatLng(37.495563, -119.885509)
            ),
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
                ],
              ),
            ),
          ),

//          FloatingActionButton(
//            elevation: 5.0,
//            foregroundColor: Color(0xFFE5D9A5),
//            backgroundColor: Color(0xEF194000),
//            child: new Icon(Icons.camera_alt, size: 45.0,),
//            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ClassifyImage())),
//          ),
        ),
      );
  }
}
