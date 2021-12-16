import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductBlock extends StatefulWidget {
  @override
  ProductBlockState createState() => ProductBlockState();
}

class ProductBlockState extends State<ProductBlock> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pW(160),
      height: pH(225),
      //color: Color(0xFFF5F5F5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF5F5F5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, pH(4), 0, pH(10)),
            child: Container(
              height: pH(110),
              width: pW(110),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: new DecorationImage(
                  image: AssetImage("images/petproducts_photo.png"),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(4), 0, pW(4), 0),
            child: Text(
              "pet food product of original brand",
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: Color(0xFF2B3B47),
                fontWeight: FontWeight.w600,
                fontSize: pH(14),
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    pW(8), pH(12), pW(8), pH(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        "₹950",
                        style: TextStyle(
                          color: Color(0xFFFF5352),
                          fontWeight: FontWeight.w600,
                          fontSize: pH(26),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: pW(26),
              ),
              IconButton(
                onPressed: () {},
                alignment: Alignment.centerRight,
                icon: new Icon(Icons.arrow_forward_ios,
                    size: pH(26), color: Color(0xFF36A9CC)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
