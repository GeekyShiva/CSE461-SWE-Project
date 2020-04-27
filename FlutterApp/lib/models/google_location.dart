import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleLocation {
  final LatLng position;
  final String areaDetails;
  final String zone;

  GoogleLocation(this.position, this.areaDetails, this.zone);

  GoogleLocation.named({this.position, this.areaDetails, this.zone});
}
