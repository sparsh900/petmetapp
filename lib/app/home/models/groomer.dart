import 'package:flutter/cupertino.dart';

class Groomer{
  Groomer({
    @required this.Name,
    @required this.clinicName,
    @required this.imagePath,
    @required this.iconPath,
    @required this.openTime,
    @required this.closeTime,
    @required this.phone,
    @required this.Address,
    @required this.city,
    @required this.state,
    @required this.zip,
    @required this.locationData,
    @required this.isHomeVisit,
    @required this.isVisitClinic,

    @required this.packages,

    @required this.cost,
    @required this.gstin,

    this.id,


    this.isChat=false,
    this.isVideo=false,
  });
  final String Name, state, phone, zip, city;
  final String Address, openTime, clinicName, imagePath, iconPath;
  final String closeTime,gstin;
  final String id;

  final List packages;

  final Map<dynamic, dynamic> locationData;
  final bool isHomeVisit;
  final bool isVisitClinic;
  final double cost;

  final bool isChat,isVideo;


  factory Groomer.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String Name = data['Name'];
      final String Address = data['Address'];
      final String city = data['city'];
      final String state = data['state'];
      final String phone = data['phone'];
      final String zip = data['zip'];
      final String closeTime = data['closeTime'];
      final String openTime = data['openTime'];
      final String clinicName = data['clinicName'];
      final String imagePath = data['imagePath'];
      final String iconPath = data['iconPath'];
      final String gstin=data['gstin'];
      final String id = documentId;
      final Map<dynamic, dynamic> locationData = data['locationData'];
      final bool isHomeVisit=data['isHomeVisit'];
      final bool isVisitClinic=data['isVisitClinic'];
      final double cost=data['cost'];
      final List packages=data['packages'];

      return Groomer(
        isVisitClinic:isVisitClinic,
        isHomeVisit:isHomeVisit,
        Name: Name,
        Address: Address,
        packages: packages,
        locationData: locationData,
        city: city,
        zip: zip,
        state: state,
        phone: phone,
        closeTime: closeTime,
        openTime: openTime,
        clinicName: clinicName,
        imagePath: imagePath,
        iconPath: iconPath,
        id:documentId,
        cost:cost,
        gstin: gstin,
        isChat:false,
        isVideo:false,
      );
    }
  }
}
