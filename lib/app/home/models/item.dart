import 'package:flutter/cupertino.dart';

class Item {
  Item({
    @required this.details,
    this.id,
    this.userSelectedQuantity,
    this.userSelectedSize,
    this.filterInfo,
  });
  final int userSelectedQuantity;
  final String userSelectedSize;
  final Map<String,dynamic> filterInfo;
  final String id;
  final Map<dynamic, dynamic> details;

  factory Item.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String id = documentId;
      final Map<dynamic, dynamic> details = data['details'];
      final int userSelectedQuantity = data["userSelectedQuantity"];
      final String userSelectedSize = data["userSelectedSize"];
      final Map<String,dynamic> filterInfo=data['filterInfo'];
      return Item(
        details: details,
        id: id,
        userSelectedQuantity: userSelectedQuantity,
        userSelectedSize: userSelectedSize,
        filterInfo: filterInfo,
      );
    }
  }

  Map<String, dynamic> cartToMap(int userSelectedQuantity,
      {@required String userSelectedSize}) {
    return {
      'details': details,
      'userSelectedQuantity': userSelectedQuantity,
      'userSelectedSize': userSelectedSize,
    };
  }

  Map<String, dynamic> wishlistToMap() {
    return {
      'details': details,
      'userSelectedQuantity': userSelectedQuantity,
      'userSelectedSize': userSelectedSize,
    };
  }
}
