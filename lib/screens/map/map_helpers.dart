import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:latlong/latlong.dart' as latlong;
import 'dart:math';

class MapHelpers {

  static double calcMileDistance(gm.LatLng a, gm.LatLng b){
    final distance = new latlong.Distance();
    latlong.LatLng latlng_a = latlong.LatLng(a.latitude, a.longitude);
    latlong.LatLng latlng_b = latlong.LatLng(b.latitude, b.longitude);
    double distanceMile = distance.as(latlong.LengthUnit.Mile, latlng_a, latlng_b);
    return distanceMile;
  }

  static double calcDistance(gm.LatLng a, gm.LatLng b){
    final distance = new latlong.Distance();
    latlong.LatLng latlng_a = latlong.LatLng(a.latitude, a.longitude);
    latlong.LatLng latlng_b = latlong.LatLng(b.latitude, b.longitude);
    final double meter = distance(latlng_a, latlng_b);
    return meter;
  }

  static double getZoomLevel(double radius) {
    double scale = radius / 5;
    double zoom = ((16 - log(scale)) / (log(2)));
    return zoom;
  }

  static gm.LatLng calcLatLngMidpoint(gm.LatLng a, gm.LatLng b){
    final distance = new latlong.Distance();
    latlong.LatLng latlng_a = latlong.LatLng(a.latitude, a.longitude);
    latlong.LatLng latlng_b = latlong.LatLng(b.latitude, b.longitude);
    num distanceMeter = distance.as(latlong.LengthUnit.Meter, latlng_a, latlng_b);
    num bearing = distance.bearing(latlng_a, latlng_b);
    latlong.LatLng mid = distance.offset(latlng_a, distanceMeter/2, bearing);
    return gm.LatLng(mid.latitude, mid.longitude);
  }

  static gm.LatLng maxDistLatLng(gm.LatLng a, List<gm.LatLng> b) {
    num maxDist = 0.0;
    gm.LatLng maxLatLng;

    for(var i = 0; i < b.length; i++) {
      num dist = calcDistance(a, b[i]);
      if (dist > maxDist) {
        maxDist = dist;
        maxLatLng = gm.LatLng(b[i].latitude, b[i].longitude);
      }
    }
    return maxLatLng;
  }

  static gm.LatLng getSW (gm.LatLng a, gm.LatLng b) {
    double lat_a = a.latitude;
    double lat_b = b.latitude;
    double long_a = a.longitude;
    double long_b = a.longitude;
    double lat_min;
    double long_min;
    if (lat_a < lat_b) {
      lat_min = lat_a;
    }
    else {
      lat_min = lat_b;
    }
    if (long_a < long_b) {
      long_min = long_a;
    }
    else {
      long_min = long_b;
    }
    return gm.LatLng(lat_min, long_min);
  }

  static gm.LatLng getNE (gm.LatLng a, gm.LatLng b) {
    double lat_a = a.latitude;
    double lat_b = b.latitude;
    double long_a = a.longitude;
    double long_b = a.longitude;
    double lat_max;
    double long_max;
    if (lat_a > lat_b) {
      lat_max = lat_a;
    }
    else {
      lat_max = lat_b;
    }
    if (long_a > long_b) {
      long_max = long_a;
    }
    else {
      long_max = long_b;
    }
    return gm.LatLng(lat_max, long_max);
  }

  static void showAlertDialog(BuildContext context, String selectedSpecies, String dropDownSelection){
    Widget confirmButton = FlatButton(
      child: Text("CONFIRM"),
      onPressed : ()  {
        selectedSpecies = dropDownSelection;
      }
    );

    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () => Navigator.of(context).pop(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Your Selection"),
        content: Text("DO you want to find the $dropDownSelection?"),
        actions: <Widget>[ confirmButton , cancelButton],
        elevation: 24.0,
        ),
      barrierDismissible: false
      );

  }

  String currentZone(double elevation){
    if (elevation >= 1800 && elevation<3000){
      return 'Foothills';
    }
    else if (elevation < 6000){
      return 'Lower Montane';
    }
    else if (elevation < 8000){
      return 'Upper Montane';
    }
    else if (elevation < 9500){
      return 'Sup-Alpine';
    }
    else if (elevation <= 13200){
      return 'Alpine';
    }
    else return 'Unknown';
  }

  static Color zoneColors (String zoneName){
    switch(zoneName){
      case 'Foothills': return  Colors.green[400];

      case 'Lower Montane': return Colors.green[200];

      case 'Upper Montane': return Colors.blue[100];

      case 'Sub-Alpine': return Colors.blue[300];

      case 'Alpine': return Colors.blue[500];

      default: return Colors.blueGrey[100];
    }
  }

  Widget zoneWidget (double elevation){
    String zoneName = currentZone(elevation);
    return Align(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width:2, color: Color(0xFF194000))
        ),
        child: Text("Current Climate:\n" + zoneName,
          style: TextStyle(
            color: zoneColors(zoneName),
//            backgroundColor : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      alignment: Alignment(-0.90, -0.8),
    );
  }



}