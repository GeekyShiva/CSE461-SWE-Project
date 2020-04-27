// import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/models/google_location.dart';
import 'package:taxi_app/repository/data_manager.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationController {

  static var locationDetails = DataManager.getLocationData();
  static var zoneDetails = DataManager.getZoneDetails();
  static var taxis = DataManager.getTaxis();

  static getLocationFromString(String locationName) async {
    for(var k in locationDetails.keys){
      debugPrint("out side near  getLocationFromString("+ locationName +")");
      var v=locationDetails[k]; 
      if(v["locationName"]==locationName){
        debugPrint("Inside  getLocationFromString("+ locationName +"): "
                  + v["LatLng"].toString() +"," +locationName.toString()+","+ v["zone"] );
        return GoogleLocation(v["LatLng"], locationName, v["zone"]);
      }
      debugPrint("Near  getLocationFromString("+ locationDetails[1]["LatLng"].toString() +"): "
                  + v["LatLng"].toString() +"," +locationName.toString()+","+ locationDetails[1]["zone"] );
    }
    return  GoogleLocation(locationDetails[1]["LatLng"], locationName, locationDetails[1]["zone"]);
  }

  static String getZoneSeverity(String locationName){
    for(var k in locationDetails.keys){
      var location = locationDetails[k];
      if(location["locationName"].toString() == locationName.toString()){
        return location["zone"].toString();
      }
    }
    return "0";
  }
  static String getLocationNameFromPosition(LatLng position){
    for(var k in locationDetails.keys){
      var location = locationDetails[k];
      if(location["position"].toString() == position.toString()){
        return location["locationName"].toString();
      }
    }
    return "Location 1";
  }

  static getDistance(LatLng position1, LatLng position2){
    var earthRadius = 6371;
    var degToRadian = 57.29578;
    var lat = degToRadian*(position2.latitude - position1.latitude);
    var lon = degToRadian*(position2.longitude - position1.longitude);

    var a = sin(lat/2)*sin(lat/2) + cos(degToRadian*(position1.latitude)) * cos(degToRadian*(position2.latitude)) * sin(lon/2)*sin(lon/2) ;
    var c = 2*asin(sqrt(a));
    var d = earthRadius * c;

    return d;
  }
  
  static String getZoneforPosition(LatLng position){
    debugPrint("driver position: " + position.toString());
    var radius = 2000; //in km
     debugPrint("distance: "+getDistance(position, zoneDetails[1]["LatLng"]).toString());
    for(var k in zoneDetails.keys){
      var v = zoneDetails[k];
      debugPrint("distance: "+getDistance(position, v["LatLng"]).toString());
      if(getDistance(position, v["LatLng"]) <= radius){
        return v["zone"];
      }
    }
    return "1";
  }

  static String getZoneFromTaxiName(String taxiName){
    for(var k in taxis.keys){
      var v = taxis[k];
      if(v["title"] == taxiName){
        return v["zone"];
      }
    }
    return "0";
  }
}
