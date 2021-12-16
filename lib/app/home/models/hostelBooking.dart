import 'package:flutter/cupertino.dart';

class HostelBooking {
  HostelBooking({
    @required this.hostelName,
    @required this.hostelId,
    @required this.cost,
    @required this.noOfDays,
    @required this.noOfHours,
    @required this.pickupDate,
    @required this.pickupTime,
    @required this.returnDate,
    @required this.returnTime,
    @required this.id,
  });
  final String hostelId,
      pickupDate,
      pickupTime,
      returnDate,
      returnTime,
      hostelName,id;
  final double cost,noOfHours;
  final int noOfDays;

  factory HostelBooking.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    } else {
      final String id = documentId;
      final String hostelName = data['hostelName'];
      final String hostelId = data['hostelId'];
      final String pickupDate = data['pickupDate'];
      final String pickupTime = data['pickupTime'];
      final String returnDate = data['returnDate'];
      final String returnTime = data['returnTime'];
      final double cost = (data['cost'] + 0.0);
      final int noOfDays = data['noOfDays'];
      final double noOfHours = data['noOfHours'];

      return HostelBooking(
        hostelName: hostelName,
        hostelId: hostelId,
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        returnDate: returnDate,
        returnTime: returnTime,
        cost: cost,
        noOfDays: noOfDays,
        noOfHours: noOfHours,
        id: id,
      );
    }
  }

  Map<String, dynamic> toMap(String uid) {
    return {
      'hostelName': hostelName,
      'hostelId': hostelId,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'returnDate': returnDate,
      'returnTime': returnTime,
      'cost': cost,
      'noOfDays': noOfDays,
      'noOfHours': noOfHours,
      'userId':uid,
    };
  }
}
