import 'package:equatable/equatable.dart';
import 'package:taxi_app/models/taxi.dart';

class TaxiDriver extends Equatable {
  final String id;
  final String driverName;
  final Taxi taxiDetails;
  final String driverPic;
  final String zone;

  TaxiDriver(this.id, this.driverName, this.driverPic,
      this.taxiDetails, this.zone);

  TaxiDriver.named(
      {this.id,
      this.driverName,
      this.driverPic,
      this.taxiDetails,
      this.zone});

  @override
  List<Object> get props =>
      [id, driverName, driverPic, taxiDetails];
}
