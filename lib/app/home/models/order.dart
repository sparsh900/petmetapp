import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order {
  Order({
    @required this.customerName,
    @required this.mobileNumber,
    this.orderId,
    this.paymentId,
    @required this.amount,
    @required this.status,
    @required this.timestamp,
    @required this.allItems,
    @required this.email,
    @required this.address,
    @required this.pincode,
  });
  String customerName,
      mobileNumber,
      orderId,
      status,
      paymentId,
      email,
      address,
      pincode;
  int amount;
  Timestamp timestamp;
  List allItems;

  factory Order.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String customerName = data['customerName'];
      final String mobileNumber = data['mobileNumber'];
      final String orderId = documentId;
      final List allItems = data['allItems'];
      final String paymentId = data['paymentId'];
      final int amount = data['amount'];
      final String status = data['status'];
      final Timestamp timestamp = data['timestamp'];
      final String email = data['email'];
      final String pincode = data['pincode'];
      final String address = data['address'];

      return Order(
          customerName: customerName,
          mobileNumber: mobileNumber,
          orderId: orderId,
          allItems: allItems,
          timestamp: timestamp,
          amount: amount,
          status: status,
          paymentId: paymentId,
          email: email,
          address: address,
          pincode: pincode);
    }
  }

  Map<String, dynamic> toMap({String status}) {
    return {
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'orderId': orderId,
      'allItems': allItems,
      'paymentId': paymentId,
      'amount': amount,
      'status': status,
      'timestamp': timestamp,
      'email': email,
      'pincode': pincode,
      'address': address
    };
  }
}
