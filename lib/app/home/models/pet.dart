import 'package:flutter/foundation.dart';

class Pet {
  Pet({@required this.name,@required this.category,@required this.breed,@required this.age,@required this.weight,@required this.id,this.image});
  String id;
  String name;
  String category;
  String breed;
  int age;
  double weight;
  String image;

  factory Pet.fromMap(Map<String, dynamic> data,String documentId) {
    if (data == null) {
      return null;
    } else {
      final String name = data['name'];
      final String category= data['category'];
      final String breed= data['breed'];
      final double weight= data['weight'];
      final int age = data['age'];
      final String image=data['image'];
      return Pet(
        id: documentId,
        name: name,
        category: category,
        breed: breed,
        weight: weight,
        age: age,
        image: image,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'breed': breed,
      'weight': weight,
      'age': age,
      'image':image,
    };
  }
}
