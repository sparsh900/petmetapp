import 'package:flutter/cupertino.dart';

class Hostel{
  Hostel({
    @required this.hostelName,
    @required this.description,
    @required this.imagePath,
    @required this.iconPath,
    @required this.phone,
    @required this.Address,
    @required this.city,
    @required this.state,
    @required this.zip,
    @required this.locationData,
    @required this.costPerHour,
    @required this.costPerDay,
    @required this.dayDuration,

    @required this.gstin,
    this.id,
  });
  final String state, phone, zip, city;
  final String Address,description, hostelName , imagePath, iconPath;
  final String gstin;
  final String id;
  final Map<dynamic, dynamic> locationData;
  final double costPerDay,costPerHour;
  final int dayDuration;

  factory Hostel.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String Address = data['Address'];
      final String city = data['city'];
      final String description = data['description'];
      final String state = data['state'];
      final String phone = data['phone'];
      final String zip = data['zip'];
      final String hostelName = data['hostelName'];
      final String imagePath = data['imagePath'];
      final String iconPath = data['iconPath'];
      final String gstin=data['gstin'];
      final Map<dynamic, dynamic> locationData = data['locationData'];
      final double costPerDay= double.parse(data['costPerDay']!=null?data['costPerDay'].toString():"4500");
      final double costPerHour= double.parse(data['costPerHour']!=null?data['costPerHour'].toString():"200");
      final int dayDuration= int.parse(data['dayDuration']!=null?data['dayDuration'].toString():"9");

      return Hostel(
        hostelName: hostelName,
        description: description,
        Address: Address,
        locationData: locationData,
        city: city,
        zip: zip,
        state: state,
        phone: phone,
        imagePath: imagePath,
        iconPath: iconPath,
        id:documentId,
        gstin: gstin,
        costPerDay: costPerDay,
        costPerHour: costPerHour,
        dayDuration: dayDuration
      );
    }
  }
}
