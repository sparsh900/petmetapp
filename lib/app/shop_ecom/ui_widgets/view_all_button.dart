import 'package:flutter/material.dart';
import '../shop_items_list/shop_items_list_page.dart';

class ShopHomeButton extends StatelessWidget {
  const ShopHomeButton({Key key, this.color, this.text = 'View All', @required this.category}) : super(key: key);
  final String category;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    double pH(double height) {
      return MediaQuery.of(context).size.height * (height / 896);
    }

    double pW(double width) {
      return MediaQuery.of(context).size.width * (width / 414);
    }

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
      width: pW(350),
      child: RaisedButton(
        color: color ?? Color(0xFF36A9CC),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w500,
            fontSize: pW(16),
            fontStyle: FontStyle.normal,
            fontFamily: "Montserrat",
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EComListPage(category: category);
          }
              // builder: (context)=>EComListPage(),
              ));
        },
      ),
    );
  }
}
