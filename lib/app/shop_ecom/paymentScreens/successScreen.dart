import 'package:flutter/material.dart';
import 'package:petmet_app/app/landing_page.dart';
import 'package:petmet_app/app/shop_ecom/previous_orders/previousOrders.dart';
import 'package:petmet_app/app/shop_ecom/wallet/walletcash.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({@required this.database});

  final Database database;
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LandingPage()),
          (Route<dynamic> route) => false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(pH(57.0)), // here the desired height
          child: AppBar(
            title: Text("ORDER  SUCCESS"),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LandingPage()),
                  (Route<dynamic> route) => false),
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/successBag.png',
              height: pH(234),
              width: pW(303),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, pH(20), 0, pH(40)),
              child: Text(
                "ORDER  PLACED  SUCCESSFULLY !!",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: pH(21)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PreviousOrders(database: widget.database),
                    ));
                  },
                  borderSide: BorderSide(
                    color: Colors.grey[700],
                  ),
                  child: Text(
                    "View Order Details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                OutlineButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WalletCash(
                        database: widget.database,
                      ),
                    ));
                  },
                  borderSide: BorderSide(
                    color: Colors.grey[700],
                  ),
                  child: Text(
                    "View Wallet",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: pH(30)),
              width: pW(300),
              child: RaisedButton(
                color: petColor,
                onPressed: () {

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LandingPage()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Continue  Shopping",
                  style: TextStyle(color: Colors.white, fontSize: pH(20)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
