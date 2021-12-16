import 'package:flutter/foundation.dart';

class UserData{
  UserData({@required this.firstName,@required this.lastName,@required this.address,@required this.phone,@required this.mail,@required this.zip,@required this.secondaryAddresses,@required this.usedPromo,@required this.walletMoney,@required this.walletHistory});
  String firstName;
  String lastName;
  String address;
  String phone;
  String mail;
  String zip;
  List secondaryAddresses;
  List usedPromo;
  int walletMoney;
  List walletHistory;

  factory UserData.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    } else {
      final String firstName = data['firstName'];
      final String lastName= data['lastName'];
      final String address= data['address'];
      final String phone = data['mobileNumber'];
      final String mail = data['mail'];
      final String zip = data['zip'];
      final List secondaryAddresses = data['secondaryAddresses'];
      final List usedPromo= data['usedPromo'];
      final int walletMoney= data['walletMoney']==null?data['walletMoney']:data['walletMoney'].truncate();
      final List walletHistory=data['walletHistory'];

      return UserData(
        firstName: firstName,
        lastName: lastName,
        address: address,
        phone: phone,
        mail: mail,
        zip: zip,
        secondaryAddresses:secondaryAddresses,
        usedPromo:usedPromo,
        walletMoney:walletMoney,
        walletHistory: walletHistory,
      );
    }
  }

  Map<String, dynamic> toMap(String deviceToken) {
    return {
      'firstName':firstName,
      'lastName':lastName,
      'address':address,
      'mobileNumber':phone,
      'mail':mail,
      'zip':zip,
      'name': firstName+' '+lastName,
      'secondaryAddresses':secondaryAddresses,
      'usedPromo':usedPromo,
      'walletMoney':walletMoney,
      'walletHistory':walletHistory,
      'deviceToken' : deviceToken,
    };
  }

  Map<String, dynamic> sendDeviceToken(String deviceToken) {
    return {
      'deviceToken' : deviceToken,
    };
  }
}