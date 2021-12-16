import 'package:flutter/foundation.dart';

class Location {
  Location({@required this.name, @required this.position});
  String name;
  Map position;

  factory Location.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String name = data['name'];
      final Map position = data['position'];
      return Location(
        name: name,
        position: position,
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
    };
  }
}
