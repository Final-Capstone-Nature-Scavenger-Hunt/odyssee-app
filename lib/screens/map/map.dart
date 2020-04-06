import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:odyssee/screens/start/start_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gpx/gpx.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:odyssee/screens/achievements/achievements.dart';
import 'package:odyssee/screens/authenticate/authenticate.dart';
import 'package:odyssee/screens/social/feed.dart';
import 'package:odyssee/screens/map/map.dart';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  GoogleMapController mapController;
  final LatLng _center = const LatLng(37.8662, -119.5422);

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Icon locationIcon = Icon(Icons.directions_walk);
  Icon sourceIcon = Icon(Icons.trip_origin);
  Icon destinationIcon = Icon(Icons.flag);

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

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
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
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
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.map,
                  color: Color(0xFFE86935),
                ),
                onPressed: () {
//                  xml =
//                  var trail = GpxReader().fromString(xml)
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              )
            ],
            backgroundColor: Colors.transparent,
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
          body: new GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
//            minMaxZoomPreference: new MinMaxZoomPreference(1, 11),
            cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
                northeast: LatLng(38.187466, -119.201724),
                southwest: LatLng(37.495563, -119.885509)
            ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            elevation: 5.0,
            foregroundColor: Color(0xFFE5D9A5),
            backgroundColor: Color(0xEF59B547),
            child: new Icon(Icons.camera_alt, size: 50.0,),
            onPressed: getImage,
          ),
        ),
      ),
    );
  }
}
