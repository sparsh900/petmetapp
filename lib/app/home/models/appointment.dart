import 'package:flutter/foundation.dart';

class Appointment {
  Appointment({this.packageName="",@required this.time,@required this.date,@required this.doctorId,this.patientId,@required this.mode,@required this.id,@required this.petName,@required this.status,this.isGroomer=false,this.userAddress,this.userName,this.userPhone,this.userZip});
  String id;
  String time;
  String date;
  String doctorId;
  String patientId;
  String mode;
  String petName;
  String status;
  bool isGroomer;
  String packageName;
  String userName,userAddress,userZip,userPhone;

  factory Appointment.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String time = data['time'];
      final String date = data['date'];
      final String doctorId = data['doctorId'];
      final String patientId = data['patientId'];
      final String mode = data['mode'];
      final String petName= data['petName'];
      final String status= data['status'];
      final bool isGroomer=data['isGroomer'] ?? false;
      final String packageName= data['packageName'];

      final String userName=data['userName']??'';
      final String userAddress=data['userAddress']??'';
      final String userPhone=data['userPhone']??'';
      final String userZip=data['userZip']??'';


      return Appointment(
        id: documentId,
        time: time,
        date: date,
        doctorId: doctorId,
        patientId: patientId,
        mode:mode,
        petName: petName,
        status: status,
        isGroomer: isGroomer,
        packageName: packageName,

        userAddress: userAddress,
        userName: userName,
        userPhone: userPhone,
        userZip: userZip
      );
    }
  }

  Map<String, dynamic> toMap(String uid) {
    return {
      'time': time,
      'date': date,
      'doctorId': doctorId,
      'patientId': uid,
      'mode': mode,
      'petName' : petName,
      'status' : status,
      'isGroomer':isGroomer,
      'packageName':packageName,
      'userName':userName,
      'userAddress':userAddress,
      'userPhone':userPhone,
      'userZip':userZip
    };
  }
}