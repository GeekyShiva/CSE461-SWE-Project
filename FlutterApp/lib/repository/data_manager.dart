
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class DataManager{
  static getLocationData(){

  var locationDetails = {
      1: {
        "LatLng": LatLng(19.03864612,72.94986531),
        "locationName": "location1 1",
        "zone": "1"
      },
      2: {
        "LatLng": LatLng(19.04327898,72.90931475),
        "locationName": "location1 2",
        "zone": "1"
      },
      3: {
        "LatLng": LatLng(19.0518025, 72.8866238),
        "locationName": "location2 1",
        "zone": "2"
      },
      4: {
        "LatLng": LatLng(19.05194475,72.82233892),
        "locationName": "location2 2",
        "zone": "2"
      },
      5: {
        "LatLng": LatLng(18.96733,72.83911),
        "locationName": "location5 1",
        "zone": "5"
      },
      6: {
        "LatLng": LatLng(18.96765438,72.8235297),
        "locationName": "location5 2",
        "zone": "5"
      }
  };


  
    return locationDetails;
  }

  static getZoneDetails(){
    var zoneDetails ={
    1: {"LatLng":LatLng(28.6472799,76.8130644) ,"zone": "1"},
    2: {"LatLng":LatLng(28.6998822,77.2549408) ,"zone": "2"},
    3: {"LatLng":LatLng(28.7000, 76.7) ,"zone": "3"},
   };

   return zoneDetails;
  }

  static getTaxis(){
    var taxis = {
      1 :{
      "id": '1',
      "position": LatLng(19.05179636,72.92460261),
      "title": "Taxi 1",
      "zone": "1",
      "plateNo": "1231"
      },
      2 : {
      "id": '2',
      "position": LatLng(19.05430542,72.83356767),
      "title": "Taxi 2",
      "plateNo": "3212",
      "zone": "2"
      },
      3: {
      "id": '3',
      "position": LatLng(18.96845022,72.82254177),
      "title": "Taxi 3",
      "plateNo": "9090",
      "zone": "5"
      }
    };
    return taxis;
  }

  static getTaxiDrivers(){
    var taxis = getTaxis();
    var drivers = {
    1: {
      "driverPic": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Sidhu_in_Punjab.jpg/440px-Sidhu_in_Punjab.jpg",
      "driverName": "Kapoor",
      "taxiDetails": taxis[4],
      "zone":"2"
      },
     2: {
      "driverPic":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Sidhu_in_Punjab.jpg/440px-Sidhu_in_Punjab.jpg",
        "driverName": "David",
        "taxiDetails": taxis[1],
        "zone": "1"
      },
     3: {
        "driverPic":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Sidhu_in_Punjab.jpg/440px-Sidhu_in_Punjab.jpg",
        "driverName": "Gopi",
        "taxiDetails": taxis[2],
        "zone": "2"
        },
     4: {
          "driverPic":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Sidhu_in_Punjab.jpg/440px-Sidhu_in_Punjab.jpg",
        "driverName": "Sibin",
        "taxiDetails": taxis[3],
        "zone": "3"
        }
  };
    return drivers;
  }

  static final Map<String, String> endPoints = {
  "getAvailableTaxis" : "http://localhost/posts",
  "allocateTaxi" : "http://localhost/posts",
  };
static Future<String> allocateTaxi(String source, String destination) async
  {
     // set up POST request arguments
      String url = endPoints["allocateTaxi"];
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"sourceLocation":'+ source+', "destination":'+ destination+'}';
      // make POST request
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // this API passes back the id of the new item added to the body
      String body = response.body;
      return body;
  }

  Future<String> getAvailableTaxis() async{
    String url = endPoints["getAvailableTaxis"];
    Response response = await get(url);
    String body = response.body;
    return body;
  }
}