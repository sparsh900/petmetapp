import 'package:flutter/material.dart';
import 'package:petmet_app/services/database.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
  MyWallet({this.database});
  final Database database;
}

class _MyWalletState extends State<MyWallet> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wallet"),
        ),
        body: Column(
          children: [
             Container(
               margin: EdgeInsets.symmetric(vertical: pH(12),horizontal: pW(12)),
             ) 
          ],
        ),
      ),
    );
  }
}
