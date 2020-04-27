import 'package:taxi_app/controllers/location_controller.dart';
import 'package:taxi_app/models/taxi.dart';
import 'package:taxi_app/models/taxi_booking.dart';
import 'package:taxi_app/models/taxi_driver.dart';
import 'package:taxi_app/repository/data_manager.dart';

class TaxiBookingController {
  static var taxiDrivers = DataManager.getTaxiDrivers();

  static var taxis = DataManager.getTaxis();
  
  static Future<double> getPrice(TaxiBooking taxiBooking) async {
    return 150;
  }

 static getTaxiDetails(Map<String, Object> details){
    return Taxi(details["id"], details["title"], true, details["plateNo"], details["position"]);
  }

  static Future<TaxiDriver> getTaxiDriver(TaxiBooking booking) async {
    var sourceZone = LocationController.getZoneSeverity(booking.source.areaDetails);
    var destinationZone = LocationController.getZoneSeverity(booking.destination.areaDetails);
    if(destinationZone == sourceZone){
      for(var k in taxiDrivers.keys){
        var driver = taxiDrivers[k];
        if(taxiDrivers[k]["zone"] == sourceZone){
          return TaxiDriver.named(
            id:k.toString(),
            driverPic:driver["driverPic"], 
            driverName:driver["driverName"], 
            taxiDetails:getTaxiDetails(driver["taxiDetails"]));
        }
      }    
  }
    return TaxiDriver.named(
      driverPic:taxiDrivers[1]["driverPic"], 
      driverName:taxiDrivers[1]["driverName"], 
      taxiDetails:getTaxiDetails(taxiDrivers[1]["taxiDetails"])
      );
}

  static Future<List<Taxi>> getTaxisAvailable() async{
    List<Taxi> taxisAvailable = [];
    taxis.forEach((k,v){
      taxisAvailable.add(
        Taxi.named(
          id: v["id"],
          title: v["title"],
          isAvailable: true,
          plateNo: v["plateNo"],
          position: v["position"],
          )
      );
    });
    return taxisAvailable;
  }
}
