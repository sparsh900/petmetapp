import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/api_path.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

class CartNumber extends ChangeNotifier {
  int _cartNumber = 0;
  int get cartNumber => _cartNumber;
  Database database;

  CartNumber(BuildContext context) {
    database = Provider.of<Database>(context, listen: false);
    CollectionReference reference = Firestore.instance.collection(APIPath.userCart(database.getUid()));
    reference.snapshots().listen((querySnapshot) {
      _cartNumber = 0;
      querySnapshot.documents.forEach((element) {
        _cartNumber += Item.fromMap(element.data, element.documentID).userSelectedQuantity;
      });
      notifyListeners();
    });
  }
}
