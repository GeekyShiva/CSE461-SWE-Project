import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/models/user_location.dart';

class UserLocationController {
  static Future<List<UserLocation>> getSavedLocations() async {
    return [
      UserLocation.named(
          name: "LocationA",
          locationType: UserLocationType.LocationA,
          position: LatLng(2, 10),
          minutesFar: 52),
      UserLocation.named(
          name: "LocationB",
          locationType: UserLocationType.LocationB,
          position: LatLng(0, 0),
          minutesFar: 36),
        UserLocation.named(
          name: "LocationC",
          locationType: UserLocationType.LocationC,
          position: LatLng(0, 0),
          minutesFar: 36),
        UserLocation.named(
          name: "LocationD",
          locationType: UserLocationType.LocationD,
          position: LatLng(0, 0),
          minutesFar: 36),
    ];
  }
}
