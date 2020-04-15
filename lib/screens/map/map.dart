import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:odyssee/data/hunt_data.dart';
import 'package:odyssee/models/line.dart';
import 'package:odyssee/data/trails.dart';
import 'package:odyssee/models/user.dart';
import 'package:odyssee/screens/classification/classification.dart';
import 'package:odyssee/screens/map/map_helpers.dart';
import 'package:odyssee/shared/header_nav.dart';
import 'package:odyssee/shared/styles.dart';
import 'package:provider/provider.dart';

class GameMap extends StatefulWidget {
  @override
  _GameMapState createState() => _GameMapState();
}

class _GameMapState extends State<GameMap> {
  GoogleMapController mapController;
  Set<Marker> _markers = Set<Marker>();
  final LatLng _center = const LatLng(37.8662, -119.5422);
  double currentElevation;

  final Set<Polyline>_polyline = {};
  String _trailName = 'Cooks Meadow Loop';
  List<LatLng> polylinePoints = List();


  List<String> species = List();
  String selectedSpecies;

  OverlayEntry _overlayEntry;
  OverlayEntry _trailsOverlayEntry;

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;

  BitmapDescriptor personalIcon;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  void setPersonalIcon() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/icons/hiking-solid-small.png');
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2), 'assets/icons/hiking-solid-small.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(5,5)), 'assets/icons/flag-checkered-solid.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    setSourceAndDestinationIcons();
    setPersonalIcon();
  }
  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();
//    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      LatLng latlng = LatLng(currentLocation.latitude, currentLocation.longitude);
      
      currentElevation = currentLocation.altitude;
      updateElevation();

      _markers.add(Marker(
        markerId: MarkerId('personalPin'),
        position: latlng,
        icon: personalIcon,
      ));
    });
    // set the initial location
    setInitialLocation();
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    LatLng latlng = LatLng(currentLocation.latitude, currentLocation.longitude);
    _markers.add(Marker(
      markerId: MarkerId('personalPin'),
      position: latlng,
      icon: personalIcon,
    ));
  }

  void showTrailPinsOnMap(List<LatLng> ppoints) {

    _markers.add(Marker(
      markerId: MarkerId('sourcePin'),
      position: ppoints.first,
      icon: sourceIcon,
    ));

//    _markers.add(Marker(
//      markerId: MarkerId('destinationPin'),
//      position: ppoints.last,
//      icon: destinationIcon,
//    ));

    print(ppoints.first);
    print(ppoints.last);
  }

  void _onChangeTrail(String trailName, GoogleMapController controller){

    print('Updating the trail');

    setState(() {
      _trailName = trailName;
      print('New trailname $_trailName');

      Line line = Line(_trailName);

      polylinePoints = line.points();
      mapController = controller;

      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        points: polylinePoints,
        width: 5,
        color: Color(0xFFE86935),
      ));

      species = line.species;

    });

    showTrailPinsOnMap(polylinePoints);

    // pan to the new position of the trail
    CameraPosition cPosition = CameraPosition(
      zoom: 16.0,
      target: polylinePoints[0],
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cPosition));


  }

  void updateElevation(){
    setState(() {
      currentElevation = currentLocation.altitude;
    });
  }

  // create hunt picture icon
  Widget _pictureIcon(String assetPath, {height, width}){
      return Image.asset(assetPath, height: height,);
    }

  // create an overlay
  OverlayEntry createOverlay(){ 
    return OverlayEntry(
    builder: (BuildContext context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Material(
              type: MaterialType.transparency,
              child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF194000),
                  border: Border.all(color: Colors.teal[400], width: 3.0)),
                margin: EdgeInsets.symmetric(horizontal:50.0, vertical: 100),
                padding: EdgeInsets.symmetric(horizontal:5.0, vertical:5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
                      child: Text(selectedSpecies,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                    _pictureIcon(HuntData.huntMap[selectedSpecies]['HuntImage']),
                    SizedBox(height: 10.0),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(HuntData.huntMap[selectedSpecies]['Hints'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                      ),
                      ),
                    )
                  ],
                ),
                ),
              ),
            ),
            onTap: () => _overlayEntry?.remove(),
          )
    );
    }

  void chooseTrail(BuildContext context, mapController){
    Widget okButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () => Navigator.of(context).pop(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select a Trail"),
        content: ListView.builder(
                  itemCount: TrailData.trailMap.keys.length,
                  itemBuilder: (BuildContext context, int index){
                    String trail = TrailData.trailMap.keys.toList()[index];
                    String difficulty = TrailData.trailMap[trail]['difficulty'] ?? "Easy";

                    return ListTile(
                      title: Text(trail),
                      trailing: Text(difficulty,
                          style: TextStyle(color: Colors.grey[350], fontSize: 15.0 )),
                      onTap: () { 
                        _onChangeTrail(trail, mapController);
                        Navigator.of(context).pop();
                        },
                      );
                  },
                  shrinkWrap: true,
                ),
        actions: <Widget>[ okButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );

  }

  void chooseSpecies(BuildContext context){
    Widget okButton = FlatButton(
      child: Text(species.isEmpty ? "OK" : "CANCEL"),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget dialogContent = species.isEmpty ? Text('Please select a Trail first') : 
                    ListView.builder(
                  itemCount: species.length,
                  itemBuilder: (BuildContext context, int index){
                    String currentSpecies = species[index];
                    String difficulty = HuntData.huntMap[currentSpecies]['DifficultyLevel'];

                    return ListTile(
                      title: Text(currentSpecies),
                      trailing: Text(difficulty,
                          style: TextStyle(color: Colors.grey[350], fontSize: 15.0 )),
                      onTap: () { 
                          setState(() {
                            selectedSpecies = currentSpecies;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                  },
                  shrinkWrap: true,
                );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Select a Species"),
        content: dialogContent,
        actions: <Widget>[ okButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    List<Widget> stackChildren = [];

    stackChildren.add( 
      GoogleMap(
              polylines: _polyline,
              markers: _markers,
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: polylinePoints.isEmpty ? _center : polylinePoints[0],
                zoom: polylinePoints.isEmpty ? 10.0 : 18.0,
              ),
//            minMaxZoomPreference: new MinMaxZoomPreference(1, 11),
              cameraTargetBounds: new CameraTargetBounds(new LatLngBounds(
                  northeast: LatLng(38.187466, -119.201724),
                  southwest: LatLng(37.495563, -119.885509)
              ),
              ),
            ));

    
    if (selectedSpecies != null){
      stackChildren.add(
      Positioned(
        child: InkWell( 
          child :_pictureIcon(HuntData.huntMap[selectedSpecies]['HuntImage']),
          onTap: () { 
            setState(() {
              _overlayEntry = createOverlay();
            }); 
            Overlay.of(context).insert(_overlayEntry); },
          ),
        right: 15,
        bottom: 90,
        height: 50,
        width: 50,
      ));
    }

    if (currentElevation != null) {
      stackChildren.add(
      MapHelpers().zoneWidget(currentElevation)
    );
    }

    stackChildren.add(
      MapHelpers().getCurrentScore(user)
    );

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: BaseAppBar(
            title: Text('Trail Map'),
            appBar: AppBar(),
          ),
          drawer: BaseDrawer(),
          body: Stack(
                    children: stackChildren,
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(
                  label:Text(''),
                  onPressed: () {
                    chooseTrail(context, mapController);
                  },
                  //tooltip: 'Choose a Trail',
                  icon: Icon(Icons.map),
                  //heroTag: null,
                ),
                FloatingActionButton(
                  elevation: 5.0,
                  foregroundColor: Color(0xFFE5D9A5),
                  backgroundColor: Color(0xEF194000),
                  child: new Icon(Icons.camera_alt, size: 45.0,),
                  onPressed: () {
                    if (selectedSpecies == null){
                      MapHelpers.showNoClassSelectAlertDialog(context);
                      return null;
                    }
                    else{
                    return Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => 
                              ClassifyImage( predictedClass : selectedSpecies)
                              )
                            );
                  }
                  },
                ),
                FlatButton.icon(
                  onPressed: () => chooseSpecies(context), 
                  icon: Icon(Icons.art_track), 
                  label: Text(''))
                // PopupMenuButton(
                //   offset: Offset(100, 100),
                //   icon: Icon(Icons.art_track),
                //   onSelected: (val) {
                //     showAlertDialog(context, val);
                //   },
                //   itemBuilder: (context) => species.map((speciesName) =>
                //     PopupMenuItem(
                //       value: speciesName,
                //       child: Text(speciesName)
                //     )
                //   ).toList()
                // ),
              ],
            ),
          ),
        ),
    );
  }
}
