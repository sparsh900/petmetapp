import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MyMap extends StatefulWidget {
  @override
  State<MyMap> createState() => MyMapSampleState();
}

class MyMapSampleState extends State<MyMap> {
  GoogleMapController mapController;
  Map<String, Marker> _markers = {};

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String get _searchText => _searchController.text;

  String _mapSearchErrorText;
  String _markerLocation = '';
  GeoPoint _markerPoint;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusColor: Colors.blue,
                  labelText: 'Search',
                  errorText: _mapSearchErrorText,
                  icon: Icon(Icons.search),
                ),
                focusNode: _searchFocus,
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onEditingComplete: _searchText == '' ? () {} : _searchLocation,
                onChanged: (searchText) {
                  setState(() {});
                },
              ),
              SizedBox(height: 8.0),
              Text(
                'Location:\n$_markerLocation',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                height: MediaQuery.of(context).copyWith().size.height - 400.0,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(20.5937, 78.9629),
                    zoom: 4,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(_markers.values),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  onTap: (latLng) =>
                      _setLocation(latLng.latitude, latLng.longitude),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchText == '' ? _getLocation : _searchLocation,
        tooltip: 'Get Location',
        child: _searchText == '' ? Icon(Icons.my_location) : Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _setLocation(double latitude, double longitude) async {
    List<Placemark> getLocation =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    setState(() {
      _searchController.clear();
      _searchFocus.unfocus();
    });

//    GeoFirePoint point = geo.point(
//        latitude: latitude,
//        longitude: longitude);
//    firestore
//        .collection('locations')
//        .add({'position': point.data, 'name': 'Yay I can be queried!'});

    _placeMarker(
      latitude: latitude,
      longitude: longitude,
      placemark: getLocation[0],
    );
  }

  void _searchLocation() async {
    setState(() {
      _mapSearchErrorText = null;
      _searchFocus.unfocus();
    });

    try {
      List<Placemark> searchLocation =
          await Geolocator().placemarkFromAddress(_searchText);
      print(searchLocation[0].position.toString()); //testing purpose
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(searchLocation[0].position.latitude,
            searchLocation[0].position.longitude),
        zoom: 17.0,
      )));
      _placeMarker(
        latitude: searchLocation[0].position.latitude,
        longitude: searchLocation[0].position.longitude,
        placemark: searchLocation[0],
      );
    } on PlatformException catch (e) {
      setState(() {
        if (e.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND' ||
            e.code == 'ERROR_GEOCODING_ADDRESS') {
          _mapSearchErrorText = 'Address not found';
        } else {
          _mapSearchErrorText = e.message;
          print(e.message);
        }
      });
    }
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      )));

      List<Placemark> _placemarkList =
          await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      _placeMarker(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        placemark: _placemarkList[0],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void _getVetLocations() {
    final Firestore _database = Firestore.instance;
    _database.collection('locations').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          _placeVetMarkers(
              docs.documents[i].data['position'], docs.documents[i].documentID);
        }
      }
    });
  }

  Future<void> _placeVetMarkers(var position, String markerIdVal) async {
    GeoPoint point = position['geopoint'];
    print(point.latitude);
    final markerId = MarkerId(markerIdVal);
    double distanceInMeters = _markerPoint == null
        ? 0.0
        : await Geolocator().distanceBetween(
            point.latitude,
            point.longitude,
            _markerPoint.latitude,
            _markerPoint.longitude,
          );
    String routeDistance = _markerPoint == null
        ? '0.0 Km'
        : await _getRouteDistance(point);
    final marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      position: LatLng(point.latitude, point.longitude),
      infoWindow: InfoWindow(
        title: 'Dr. ABC',
        snippet: ("${distanceInMeters.ceil() / 1000} Km Away ,Route : $routeDistance"),
      ),
    );

    setState(() {
      // adding a new marker to map
      _markers[markerIdVal] = marker;
    });
  }

  void _placeMarker({double latitude, double longitude, Placemark placemark}) {
    setState(() {
      _markerLocation = placemark.name + "," + placemark.subLocality;
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(latitude, longitude),
      );
      _markers["Current Location"] = marker;

      _markerPoint = GeoPoint(latitude, longitude);
    });
    _getVetLocations();
  }

  _onMapCreated(GoogleMapController controller) {
    _getVetLocations();
    setState(() {
      mapController = controller;
    });
  }

  Future<String> _getRouteDistance(GeoPoint point) async {
    Dio dio = new Dio();
    try {
      Response response = await dio
          .get("https://maps.googleapis.com/maps/api/distancematrix/json?"
          "units=metric"
          "&origins=${_markerPoint.latitude},${_markerPoint.longitude}"
          "&destinations=${point.latitude},${point.longitude}"
          "&key=AIzaSyDCMg6tvDBS_t_-pvT-uN395JdQrjfCbR4");
      Map responseMap = response.data;
      //print(responseMap);
      String distance = responseMap["rows"][0]["elements"][0]["distance"]["text"];
      return distance;
    } catch (e) {
      print(e.toString());
      return 'Error Calculating Distance';
    }
  }
}
