import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

abstract class AbstractLocationFunctions {
  Future<Map<String, dynamic>> getLocation();
  Future<Map<String, dynamic>> getRouteDistance(Map<String, dynamic> userLocationData, Map<String, dynamic> vetLocationData);
  // Stream<List> streamAfterCalculatingDistanceFromUser(Stream<List> listOfWorkers, Map<String, dynamic> locationData);
}

class LocationFunctions implements AbstractLocationFunctions {

  String mapsAPIKey="AIzaSyBhcoax9k-GeiyCxaNvtTfVK2oFOxgdQrw";

  Future<Map<String, dynamic>> getLocation() async {
    print("Getting User Location");
    try {
      var _currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((value) {
        return value;
      });
      return Geolocator()
          .placemarkFromCoordinates(
        _currentLocation.latitude,
        _currentLocation.longitude,
      )
          .then((value) {
        String str = value[0].name + "," + value[0].subLocality;
        return {"latitude": _currentLocation.latitude, "address": str, "longitude": _currentLocation.longitude};
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getRouteDistance(Map<String, dynamic> userLocationData, Map<String, dynamic> workerLocationData) async {
    print("Difference in distance between worker and user calculated");
    Dio dio = new Dio();
    try {
      return dio
          .get("https://maps.googleapis.com/maps/api/distancematrix/json?"
              "units=metric"
              "&origins=${workerLocationData["latitude"]},${workerLocationData["longitude"]}"
              "&destinations=${userLocationData["latitude"]},${userLocationData["longitude"]}"
              "&key=$mapsAPIKey")
          .then((response) {
        Map responseMap = response.data;
        Map<String, dynamic> distance = responseMap["rows"][0]["elements"][0]["distance"];
        return distance;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Stream<List> streamAfterCalculatingDistanceFromUser(Stream<List> listOfWorkers, Map<String, dynamic> locationData) async* {
  //   List dataToReturn = List();
  //   await for (List list in listOfWorkers) {
  //     for (var worker in list) {
  //       Map<String, dynamic> dataMap = Map<String, dynamic>();
  //       Map<String, dynamic> extraData = await getRouteDistance(locationData, worker.locationData);
  //       dataMap["calculatedLocationData"] = extraData;
  //       dataMap["workerData"] = worker;
  //       if (dataMap["calculatedLocationData"] == null) continue;
  //       //to add according to distance
  //       int i = 0;
  //       for (; i < dataToReturn.length; i++) {
  //         if (dataToReturn[i]["calculatedLocationData"]["value"] > dataMap["calculatedLocationData"]["value"]) {
  //           break;
  //         }
  //       }
  //       dataToReturn.insert(i, dataMap);
  //     }
  //     yield dataToReturn;
  //   }
  // }
}
