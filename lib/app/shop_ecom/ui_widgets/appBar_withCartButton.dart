import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../cart/cart.dart';

PreferredSize buildAppBar(BuildContext context, Database database, cartNumber) {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  return PreferredSize(
    preferredSize: Size.fromHeight(pH(54.0)), // here the desired height
    child: AppBar(
      backgroundColor: Color(0xFFF1F1F1),
      elevation: 0,
      iconTheme: IconThemeData(
        color: Color(0xFF343434),
      ),
      centerTitle: true,
      title: Image.asset(
        'images/petmet-logo.png',
        width: pW(130),
        height: pH(33),
      ),
      actions: <Widget>[
        /*Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
          child: InkWell(
            onTap: () {},
            child: Icon(Icons.search),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 10, 0),
          child: InkWell(
            onTap: () {
              CartNumber myCartNumber = Provider.of<CartNumber>(context, listen: false);
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider<CartNumber>.value(
                      value: myCartNumber,
                      child: CartPage(database: database),
                    )),
              );
              // Navigator.of(context, rootNavigator: true).push(
              //   MaterialPageRoute<void>(
              //     fullscreenDialog: true,
              //     builder: (context) => CartPage(database: database),
              //   ),
              // ),
            },
            child: Badge(
              badgeColor: metColor,
              shape: BadgeShape.circle,
              position: BadgePosition.topEnd(top: -4, end: -6),
              badgeContent: Text(
                cartNumber.toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ],
    ),
  );
}
