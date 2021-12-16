/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/show_vet_locations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: FireMap()
        )
    );
  }
}

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}


class FireMapState extends State<FireMap> {
    // widgets go here
    GoogleMapController mapController;

    build(context) {
      return Stack(
          children: [
            GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
                onMapCreated: _onMapCreated,
                myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
                mapType: MapType.hybrid,
                trackCameraPosition: true
            ),
      Positioned(
      bottom: 50,
      right: 10,
      child:
      FlatButton(
      child: Icon(Icons.pin_drop),
      color: Colors.green,
      onPressed: () => _addMarker()
      )
      )



          ]
      );
    }

    _addMarker() {
      var marker = Marker(
          position: mapController.cameraPosition.target,
          icon: BitmapDescriptor.defaultMarker,
          infoWindowText: InfoWindowText('Magic Marker', '🍄🍄🍄')
      );

      mapController.addMarker(marker);
    }

    void _onMapCreated(GoogleMapController controller) {
      setState(() {
        mapController = controller;
      });
    }

  }*/
//}

/*import 'package:location/show_vet_locations.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

//void main() => runApp(MyApp());

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: FireMap(),
        )
    );
  }
}

class FireMap extends StatefulWidget {
  State createState() => FireMapState();
}


class FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location location = new Location();

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  //Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject();
  //final radius = BehaviorSubject<double>(seedValue: 100.0);
  Stream<dynamic> query;

  // Subscription
  StreamSubscription subscription;

  build(context) {
    return Stack(children: [

      GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(24.142, -110.321),
            zoom: 15
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        compassEnabled: true,
        trackCameraPosition: true,
      ),
      Positioned(
          bottom: 50,
          right: 10,
          child:
          FlatButton(
              child: Icon(Icons.pin_drop, color: Colors.white),
              color: Colors.green,
              onPressed: _addGeoPoint
          )
      ),
      /*Positioned(
          bottom: 50,
          left: 10,
          child: (
            min: 100.0,
            max: 500.0,
            divisions: 4,
            value: radius.value,
            label: 'Radius ${radius.value}km',
            activeColor: Colors.green,
            inactiveColor: Colors.green.withOpacity(0.2),
            onChanged: _updateQuery,
          )
      )*/
    ]);
  }

  // Map Created Lifecycle Hook
  _onMapCreated(GoogleMapController controller) {
    //_startQuery();
    setState(() {
      mapController = controller;
    });
  }

  void _addMarker() async{
    var marker = MarkerOptions(
        position: mapController.cameraPosition.target,
        //icon: BitmapDescriptor.,

        icon: BitmapDescriptor.defaultMarker,//{
          /*path: google.maps.SymbolPath.CIRCLE,
         // scale: 10
       // },*/
        draggable: true,
        infoWindowText: InfoWindowText('Magic Marker', '🍄🍄🍄')
    );

    mapController.addMarker(marker);
  }

  void _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17.0,
        )
    )
    );
  }

  // Set GeoLocation Data
  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(
        latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('locations').add({
      'position': point.data,
      'name': 'Yay I can be queried!'
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);
    mapController.clearMarkers();
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data['position']['geopoint'];
      double distance = document.data['distance'];
      var marker = MarkerOptions(
          position: LatLng(pos.latitude, pos.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindowText: InfoWindowText(
              'Magic Marker', '$distance kilometers from query center')
      );


      mapController.addMarker(marker);
    });
  }

  _startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;


    // Make a referece to firestore
    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center,
          radius: rad,
          field: 'position',
          strictMode: true
      );
    }).listen(_updateMarkers);
  }

    _updateQuery(value) {
      final zoomMap = {
        100.0: 12.0,
        200.0: 10.0,
        300.0: 7.0,
        400.0: 6.0,
        500.0: 5.0
      };
      final zoom = zoomMap[value];
      mapController.moveCamera(CameraUpdate.zoomTo(zoom));

      setState(() {
        radius.add(value);
      });
    }

    @override
    dispose() {
      subscription.cancel();
      super.dispose();
    }
  }*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputLocation extends StatefulWidget {
  @override
  State<InputLocation> createState() => InputLocationState();
}

class InputLocationState extends State<InputLocation> {
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _searchText == '' ? _getLocation : _searchLocation,
            tooltip: 'Get Location',
            child: _searchText == ''
                ? Icon(Icons.my_location)
                : Icon(Icons.search),
            heroTag: null,
          ),
          SizedBox(width: 50.0),
          FloatingActionButton(
            onPressed: () => _submitLocation(),
            tooltip: 'Submit Location',
            backgroundColor: Colors.pink,
            child: Icon(Icons.done),
            heroTag: null,
          ),
        ],
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
  }

  void _submitLocation() {
    if (_markerPoint != null) {
      GeoFirePoint point = geo.point(
          latitude: _markerPoint.latitude, longitude: _markerPoint.longitude);
      firestore
          .collection('locations')
          .add({'position': point.data, 'name': 'Yay I can be queried!'});
      print("sucess map");
      Navigator.pop(context);
    } else {
      showPlatformDialog(
        context: context,
        builder: (context) {
          return PlatformAlertDialog(
            title: Text('Location not Selected'),
            content: Text('Please select a location to proceed'),
            actions: <Widget>[
              PlatformDialogAction(
                child: PlatformText('OK'),
                onPressed: Navigator.of(context).pop,
              )
            ],
          );
        },
      );
    }
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
