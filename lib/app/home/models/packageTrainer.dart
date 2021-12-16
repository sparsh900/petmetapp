import 'package:flutter/cupertino.dart';

class PackageTrainer{

  PackageTrainer({
    this.isOnline,
    this.isHomeVisit,
    this.isTrainingCentre,
    @required this.packageName,
    this.durationInMonths,
    @required this.description,
    this.homeVisitCharges,
    this.trainingCentreCharges,
    this.onlineCharges,
    this.id,
  });

  final String id,packageName,description;
  final bool isOnline , isHomeVisit, isTrainingCentre;
  final int homeVisitCharges,trainingCentreCharges,onlineCharges,durationInMonths;



  @override
  String toString(){
    return "{id: $id,packageName: $packageName,isOnline: $isOnline,isHomeVisit: $isHomeVisit ,isTrainingCentre: $isTrainingCentre}";
  }

  factory PackageTrainer.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String id = documentId;
      final String packageName = data['packageName'];
      final String description = data['description'];
      final bool isOnline=data['isOnline'] ?? false;
      final bool isHomeVisit=data['isHomeVisit'] ?? false;
      final bool isTrainingCentre=data['isTrainingCentre'] ?? false;

      final int homeVisitCharges=int.parse(data['homeVisitCharges'] != null ? data['homeVisitCharges'].toString() : "0");
      final int trainingCentreCharges=int.parse(data['trainingCentreCharges']!= null ? data['trainingCentreCharges'].toString():"0");
      final int onlineCharges=int.parse(data['onlineCharges']!= null ? data['onlineCharges'].toString():"0");
      final int durationInMonths=int.parse(data['durationInMonths']!= null ? data['durationInMonths'].toString():"1");

      return PackageTrainer(
        description: description,
        packageName: packageName,
        isOnline: isOnline,
        isHomeVisit: isHomeVisit,
        isTrainingCentre: isTrainingCentre,
        homeVisitCharges: homeVisitCharges,
        trainingCentreCharges: trainingCentreCharges,
        onlineCharges: onlineCharges,
        id: id,
        durationInMonths: durationInMonths,
      );

    }
  }
}