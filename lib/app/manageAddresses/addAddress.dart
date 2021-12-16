import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/services/database.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petmet_app/main.dart';
import 'package:location/location.dart' as gpsNative;


class AddAddress extends StatefulWidget {
  AddAddress({this.database,this.editAddress});
  final Database database;
  final Map<String,dynamic> editAddress;
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  GoogleMapController mapController;
  Map<String, Marker> _markers = {};

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final focusNode = new FocusNode();

  final FocusNode _searchFocus = FocusNode();
  String get _searchText => _addressController.text;

  String _mapSearchErrorText;
  // String _markerLocation = '';
  GeoPoint _markerPoint;

  @override
  void initState(){
    super.initState();
    if(widget.editAddress != null){
      _addressController.text=widget.editAddress['address'];
      _pinCodeController.text=widget.editAddress['zip'];
      _nameController.text=widget.editAddress['name'];
      _phoneController.text=widget.editAddress['phone'].toString().substring(2);
    }
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await gpsNative.Location().requestService();

      var status = await Permission.location.status;
      if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
        await openAppSettings();
      }
      if(widget.editAddress==null)
        _getLocation();
      else
        _searchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text((widget.editAddress==null?"ADD":"EDIT") + "  ADDRESS",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: pH(316),
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
                  onTap: (latLng) => _setLocation(latLng.latitude, latLng.longitude),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 5,
                child: RaisedButton(color: Color(0xFFFF5352),
                    onPressed: () async{
                      await gpsNative.Location().requestService();

                      var status = await Permission.location.status;
                      if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
                        await openAppSettings();
                      }
                      _getLocation();
                    },
                    child: Icon(Icons.my_location, color: Colors.white)),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add  New  Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: pH(16)),
                        child: TextFormField(
                          validator: (value) => value.isEmpty?"Empty !!":null,
                          controller: _nameController,
                          style: TextStyle(color: petColor, fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF2F2F2),
                            border: InputBorder.none,
                            //border: const OutlineInputBorder(),
                            labelText: 'Your Name',
                            labelStyle: TextStyle(color: Color(0xFFA7A7A7), fontSize: 16, fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: pH(16)),
                        child: TextFormField(
                          validator: (value) => value.isEmpty?"Empty !!":null,
                          focusNode: focusNode,
                          controller: _addressController,
                          style: TextStyle(color: Color(0xFFA7A7A7), fontSize: 18, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              //border: const OutlineInputBorder(),
                              border: InputBorder.none,
                              labelText: 'House, Locality, City, State',
                              labelStyle: TextStyle(color: Color(0xFFA7A7A7), fontSize: 16, fontWeight: FontWeight.w200),
                              suffixIcon: IconButton(onPressed: _searchLocation, icon: Icon(MyFlutterApp.location, color: Colors.grey[700]))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: pH(16)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _pinCodeController,
                                  validator: (value) {
                                    if(value.isEmpty)
                                      return "Empty !!";
                                    else if(value.length==6 && value[0] != '0')
                                    {
                                      return null;
                                    }else{
                                      return "Wrong pin code !!";
                                    }
                                  },
                                  style: TextStyle(color: Color(0xFFA7A7A7), fontSize: 18, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF2F2F2),
                                    //border: const OutlineInputBorder(),
                                    border: InputBorder.none,
                                    labelText: 'Pin Code',
                                    labelStyle: TextStyle(color: Color(0xFFA7A7A7), fontSize: 16, fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ),
                              SizedBox(width: pW(12),),
                              Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _phoneController,
                                    validator: (value) {
                                          if(value.isEmpty)
                                            return "Empty !!";
                                          else if(value.length!=10)
                                            return "10 digits only";
                                          else if( int.parse(value[0])<6 )
                                            return "Wrong number !!";
                                          else
                                            return null;
                                    },
                                    style: TextStyle(color: petColor, fontSize: 18, fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFF2F2F2),
                                      prefixText: "+91",
                                      border: InputBorder.none,
                                      labelText: 'Phone Number',
                                      labelStyle: TextStyle(color: Color(0xFFA7A7A7), fontSize: 16, fontWeight: FontWeight.w200),
                                    ),
                                  ))
                            ]),
                      ),
                      Container(
                        width: pW(414),
                          height: pH(50),
                          margin: EdgeInsets.only(right: pW(4),top: pH(40),bottom: pH(18), left: pW(4)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(pH(20))
                          ),
                          //alignment: Alignment.topRight,
                          child: FlatButton(
                            textColor: Color(0xFFFFFFFF),
                            color: Color(0xFF36A9CC),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(pH(25))),
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                print("Validated");
                                Navigator.pop(context,{
                                  "address": _addressController.text,
                                  "phone":   "91"+_phoneController.text,
                                  "name":    _nameController.text,
                                  "zip":     _pinCodeController.text
                                });
                              }
                            },
                            child: Text("Proceed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),)
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      )));

      List<Placemark> _placemarkList = await Geolocator().placemarkFromCoordinates(
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

  void _searchLocation() async {
    setState(() {
      _mapSearchErrorText = null;
      _searchFocus.unfocus();
      focusNode.unfocus();
    });

    try {
      List<Placemark> searchLocation = await Geolocator().placemarkFromAddress(_searchText);
      print(searchLocation[0].position.toString()); //testing purpose
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(searchLocation[0].position.latitude, searchLocation[0].position.longitude),
        zoom: 17.0,
      )));
      _placeMarker(
        latitude: searchLocation[0].position.latitude,
        longitude: searchLocation[0].position.longitude,
        placemark: searchLocation[0],
      );
    } on PlatformException catch (e) {
      setState(() {
        if (e.code == 'ERROR_GEOCODNG_ADDRESSNOTFOUND' || e.code == 'ERROR_GEOCODING_ADDRESS') {
          _mapSearchErrorText = 'Address not found';
        } else {
          _mapSearchErrorText = e.message;
          print(e.message);
        }
      });
    }
  }

  void _placeMarker({double latitude, double longitude, Placemark placemark}) {
    setState(() {
      _addressController.text = placemark.name + ", " + (placemark.subLocality != "" ? (placemark.subLocality + ", ") : "") +
          placemark.subAdministrativeArea + ", " + placemark.administrativeArea;
      _pinCodeController.text = placemark.postalCode;
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(latitude, longitude),
      );
      _markers["Current Location"] = marker;

      _markerPoint = GeoPoint(latitude, longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _setLocation(double latitude, double longitude) async {
    List<Placemark> getLocation = await Geolocator().placemarkFromCoordinates(latitude, longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17.0,
    )));
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
}

