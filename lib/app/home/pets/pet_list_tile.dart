import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/pet.dart';

class PetListTile extends StatelessWidget {
  PetListTile({@required this.pet, this.onTap});

  final Pet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pet.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
