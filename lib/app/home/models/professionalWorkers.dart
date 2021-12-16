import 'package:flutter/cupertino.dart';

class ProfessionalWorkers{
   final String Name, experience, state, phone, zip, city, Achievements;
   final String Address, openTime, clinicName, imagePath, iconPath;
   final String Qualification, closeTime;
   final String id;
   final Map<dynamic, dynamic> locationData;
   final bool isHomeVisit;
   final bool isVisitClinic;
   final bool isChat;
   final bool isVideo;


   ProfessionalWorkers({
      @required this.Name,
      @required this.clinicName,
      @required this.imagePath,
      @required this.iconPath,
      @required this.openTime,
      @required this.closeTime,
      @required this.phone,
      @required this.experience,
      @required this.Achievements,
      @required this.Address,
      @required this.Qualification,
      @required this.city,
      @required this.state,
      @required this.zip,
      @required this.locationData,
      @required this.isHomeVisit,
      @required this.isVisitClinic,
      @required this.isChat,
      @required this.isVideo,
      this.id,
   });

   @override
   String toString(){

     return "{Name: $Name,Address: $Address,Qualification: $Qualification,locationData: $locationData,Achievements: $Achievements,city: $city,zip: $zip,state: $state,experience: $experience,phone: $phone,closeTime: $closeTime,openTime: $openTime,clinicName: $clinicName,imagePath: $imagePath,iconPath: $iconPath,id:documentId,isChat:$isChat,isVideo:$isVideo,isVisitClinic:${isVisitClinic.toString()},isHomeVisit:$isHomeVisit,}";
   }

   factory ProfessionalWorkers.fromMap(Map<String, dynamic> data,String documentId) {
      if (data == null) {
         return null;
      } else {
        final bool isHomeVisit=data['isHomeVisit'];
        final bool isVisitClinic=data['isVisitClinic'];
        final bool isChat=data['isChat'];
        final bool isVideo=data['isVideo'];

         final String Name = data['Name'];
         final String Address = data['Address'];
         final String Qualification = data['Qualification'];
         final String Achievements = data['Achievements'];
         final String city = data['city'];
         final String experience = data['experience'];
         final String state = data['state'];
         final String phone = data['phone'];
         final String zip = data['zip'];
         final String closeTime = data['closeTime'];
         final String openTime = data['openTime'];
         final String clinicName = data['clinicName'];
         final String imagePath = data['imagePath'];
         final String iconPath = data['iconPath'];

         final String id = documentId;
         final Map<dynamic, dynamic> locationData = data['locationData'];
         return ProfessionalWorkers(

           isChat:isChat,
           isVideo:isVideo,
           isVisitClinic:isVisitClinic,
           isHomeVisit:isHomeVisit,

             Name: Name,
             Address: Address,
             Qualification: Qualification,
             locationData: locationData,
             Achievements: Achievements,
             city: city,
             zip: zip,
             state: state,
             experience: experience,
             phone: phone,
             closeTime: closeTime,
             openTime: openTime,
             clinicName: clinicName,
             imagePath: imagePath,
             iconPath: iconPath,
             id:documentId,
         );
      }
   }
}