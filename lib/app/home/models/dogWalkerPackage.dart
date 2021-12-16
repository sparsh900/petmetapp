import 'package:flutter/foundation.dart';

class DogWalkerPackage {
  DogWalkerPackage({@required this.id,@required this.cost,@required this.durationInMonths,@required this.description});
  String id;
  int durationInMonths;
  double cost;
  String description;

  factory DogWalkerPackage.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String description = data['description'];
      final int durationInMonths = data['durationInMonths'];
      final double cost = (data['cost']+0.00);
      return DogWalkerPackage(
        id: documentId,
        description: description,
        durationInMonths: durationInMonths,
        cost: cost,
      );
    }
  }
}