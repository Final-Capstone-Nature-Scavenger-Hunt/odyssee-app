import 'package:odyssee/data/trails.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Line {

  final trailName;

  Line(this.trailName);

  LatLng _listToLatLng(List pointDetails){
    return LatLng(pointDetails[0], pointDetails[1]);
  }

  List<LatLng> points (){
    List<List> pointList = TrailData.trailMap[trailName]['points'];
    return pointList.map(_listToLatLng).toList();
  }

  List<String> get species {
    List<String> speciesList = TrailData.trailMap[trailName]['species'];
    speciesList.sort((a,b)=> a.toLowerCase().compareTo(b.toLowerCase()));
    return speciesList;
  }
}