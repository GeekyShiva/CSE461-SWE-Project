import 'package:google_maps_flutter/google_maps_flutter.dart';

enum UserLocationType { LocationA, LocationB, LocationC, LocationD }

class UserLocation {
  final String name;
  final UserLocationType locationType;
  final LatLng position;
  final int minutesFar;

  UserLocation(this.name, this.locationType, this.position, this.minutesFar);

  UserLocation.named({
    this.name,
    this.locationType,
    this.position,
    this.minutesFar,
  });
}