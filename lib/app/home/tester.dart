import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/shop_ecom/cart/cart.dart';
import 'package:petmet_app/app/sign_in/show_vet_locations.dart';
import 'package:petmet_app/app/sign_in/sign_in_button.dart';
import 'package:petmet_app/common_widgets/input_location.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

import 'locations_page.dart';
class Tester extends StatefulWidget {
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }
  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
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
          leading: IconButton(
            icon: Icon(
              Icons.sort,
              size: 28,
            ),
            onPressed: () {},//=> _scaffoldKey.currentState.openDrawer(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.search),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.notifications),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            SignInButton(
              text: 'Map Tester',
              icon: Icons.map,
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => MyMap(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SignInButton(
              text: 'Input Location Tester',
              icon: Icons.map,
              color: Colors.pink,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (context) => InputLocation(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SignInButton(
              text: 'List retrieve Tester',
              icon: Icons.print,
              color: Colors.pink,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (context) => LocationsPage(database: database),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SignInButton(
              text: 'Show Cart',
              icon: Icons.add_shopping_cart,
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () => Navigator.of(context,rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (context) => CartPage(database: database),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
