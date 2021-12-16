import 'package:flutter/foundation.dart';

class AdoptPet {
  AdoptPet(
      {@required this.color,
      @required this.name,
      @required this.category,
      @required this.breed,
      @required this.age,
      @required this.gender,
      @required this.weight,
      @required this.id,
      this.image,
      @required this.description,
      @required this.locationData,
      this.ownerId});
  String id;
  String name;
  String color;
  String category;
  String breed;
  double age;
  String gender;
  double weight;
  List<dynamic> image;
  String description;
  String ownerId;
  final Map<dynamic, dynamic> locationData;

  factory AdoptPet.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String color = data['color'];
      final String name = data['name'];
      final String category = data['category'];
      final String breed = data['breed'];
      final double weight = data['weight'];
      final double age = data['age'];
      final String gender = data['gender'];
      final List<dynamic> image = data['image'];
      final String description = data['description'];
      final String ownerId = data['ownerId'];
      final Map<dynamic, dynamic> locationData = data['locationData'];
      return AdoptPet(
        id: documentId,
        name: name,
        color: color,
        category: category,
        breed: breed,
        weight: weight,
        gender: gender,
        age: age,
        image: image,
        description: description,
        locationData: locationData,
        ownerId: ownerId,
      );
    }
  }

  Map<String, dynamic> toMap({@required String ownerId}) {
    return {
      'color': color,
      'name': name,
      'category': category,
      'breed': breed,
      'weight': weight,
      'gender': gender,
      'age': age,
      'image': image,
      'description': description,
      'locationData': locationData,
      'ownerId': ownerId
    };
  }
}
