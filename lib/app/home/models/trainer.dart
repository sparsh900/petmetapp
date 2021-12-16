import 'package:flutter/cupertino.dart';

class Trainer {
  Trainer({
    @required this.description,
    this.id,
  });

  final String id;
  final String description;

  @override
  String toString() {
    return "{id: $id, description: $description}";
  }

  factory Trainer.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String description = data['description'];
      final String id = documentId;
      // final List<dynamic> packagesDB =  data['packages'].toList();
      // List<PackageTrainer> packages= packagesDB.map((e) =>PackageTrainer.fromMap(e)).toList();

      return Trainer(
        description: description,
        // packages: packages,
        id: documentId,
      );
    }
  }
}
