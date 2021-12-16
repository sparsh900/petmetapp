import 'package:flutter/cupertino.dart';

class Promo {
  Promo(
      {
      @required this.description,
      @required this.discount,
      @required this.discountLowerLimit,
      @required this.discountUpperLimit,
      @required this.reUsable,
      @required this.walletCashback,
      @required this.walletCashbackMaxima,
                this.code
      });
  final String description, discount, discountLowerLimit, discountUpperLimit, walletCashback, walletCashbackMaxima;
  final bool reUsable;
  String code;

  factory Promo.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String description = data['description'];
      final String discount = data['discount'];
      final String  discountLowerLimit= data['discountLowerLimit'];
      final String discountUpperLimit = data['discountUpperLimit'];
      final String  walletCashback= data['walletCashback'];
      final String walletCashbackMaxima = data['walletCashbackMaxima'];
      final bool reUsable = data['reUsable'];

      return Promo(
        description: description,
        discount: discount,
        discountLowerLimit: discountLowerLimit,
        discountUpperLimit: discountUpperLimit,
        walletCashback: walletCashback,
        walletCashbackMaxima: walletCashbackMaxima,
        reUsable: reUsable,
        code:documentId,
      );
    }
  }
}
