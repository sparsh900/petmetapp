import 'package:flutter/foundation.dart';

class MyDogWalkerPackage {
  MyDogWalkerPackage({@required this.id,@required this.cost,@required this.durationInMonths,@required this.description,@required this.time,@required this.packageId,@required this.petId,@required this.petName,@required this.paymentVerified});
  String id;
  int durationInMonths;
  double cost;
  String description;
  String time;
  String packageId;
  String petId;
  String petName;
  bool paymentVerified;

  factory MyDogWalkerPackage.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String description = data['description'];
      final int durationInMonths = data['durationInMonths'];
      final double cost = (data['cost']+0.00);
      final String packageId = data['packageId'];
      final String time = data['time'];
      final String petId = data['petId'];
      final String petName = data['petName'];
      final bool paymentVerified = data['paymentVerified'];
      return MyDogWalkerPackage(
        id: documentId,
        description: description,
        durationInMonths: durationInMonths,
        cost: cost,
        time: time,
        packageId: packageId,
        petId: petId,
        petName: petName,
        paymentVerified: paymentVerified,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'description':description,
      'durationInMonths':durationInMonths,
      'cost':cost,
      'packageId':packageId,
      'time':time,
      'petName':petName,
      'petId':petId,
      'paymentVerified':paymentVerified,
    };
  }
}