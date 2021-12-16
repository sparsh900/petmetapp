import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:petmet_app/app/home/models/vet.dart';

abstract class VetsFunctions {
  Stream<List> aStream(
      Stream<List<Vet>> vets, Map<String, dynamic> locationData);
  Future<Map<String, dynamic>> getLocation();
  Future<Map<String, dynamic>> getRouteDistance(
      Map<String, dynamic> userLocationData,
      Map<String, dynamic> vetLocationData);
}

class VetsLogicFunctions implements VetsFunctions {
  Future<Map<String, dynamic>> getLocation() async {
    try {
      var _currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((value) {
        return value;
      });
      return Geolocator()
          .placemarkFromCoordinates(
        _currentLocation.latitude,
        _currentLocation.longitude,
      )
          .then((value) {
        String str = value[0].name + "," + value[0].subLocality;
        print(str);
        print(_currentLocation);
        return {
          "latitude": _currentLocation.latitude,
          "address": str,
          "longitude": _currentLocation.longitude
        };
      });
    } catch (e) {
      print(e);
      return null;

    }
  }

  Future<Map<String, dynamic>> getRouteDistance(
      Map<String, dynamic> userLocationData,
      Map<String, dynamic> vetLocationData) async {
    Dio dio = new Dio();
    try {
      return dio
          .get("https://maps.googleapis.com/maps/api/distancematrix/json?"
              "units=metric"
              "&origins=${vetLocationData["latitude"]},${vetLocationData["longitude"]}"
              "&destinations=${userLocationData["latitude"]},${userLocationData["longitude"]}"
              "&key=AIzaSyBhcoax9k-GeiyCxaNvtTfVK2oFOxgdQrw").then((response) {
        
        print("Hello");
        Map responseMap = response.data;
        print(responseMap);
        Map<String, dynamic> distance = responseMap["rows"][0]["elements"][0]["distance"];
        return distance;
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List> aStream(Stream<List<Vet>> vets, Map<String, dynamic> locationData) async* {
    List dataToReturn = List();
    await for (List<Vet> q in vets) {
      for (var vet in q) {
        Map<String, dynamic> dataMap = Map<String, dynamic>();
        Map<String, dynamic> extraData = await getRouteDistance(locationData, vet.locationData);
        dataMap["extraData"] = extraData;
        dataMap["vetData"] = vet;
        if(dataMap["extraData"]==null)
          continue;
        //to add according to distance
        int i=0;
        for(;i<dataToReturn.length;i++){

          if(dataToReturn[i]["extraData"]["value"]>dataMap["extraData"]["value"]){
            break;
          }
        }
        dataToReturn.insert(i,dataMap);
      }
      yield dataToReturn;
    }
  }
}
