import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/cartNumberNotifier.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

//module level imports
import '../item_page/item_page.dart';

class EComListCard extends StatefulWidget {
  EComListCard({@required this.itemData, @required this.database});
  final Item itemData;
  final Database database;
  @override
  _EComListCardState createState() => _EComListCardState();
}

class _EComListCardState extends State<EComListCard> {
  bool _addedToCart=false;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  Future<void> addToCart() async {
    setState(() {
      _addedToCart=true;
    });
    await widget.database.setCartItem(widget.itemData, widget.itemData.details["size"][0]);
    Timer(Duration(seconds: 1), () {
      setState(() {
        _addedToCart = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // INFO:: this is only for
        CartNumber myCartNumber = Provider.of<CartNumber>(context, listen: false);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<CartNumber>.value(
                    value: myCartNumber,
                    child: ShowItemPage(itemData: widget.itemData, database: widget.database),
                  )),
        );
      },
      child: SizedBox(
        height: pH(230),
        width: pW(162),
        child: Container(
          //margin: EdgeInsets.symmetric(horizontal: pW(5)),
          padding: EdgeInsets.symmetric(horizontal: pW(9)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFFFFFFF),
            boxShadow: [
              new BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 7, offset: Offset(0, 0)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: pH(120),
                width: pW(104),
                margin: EdgeInsetsDirectional.fromSTEB(pW(18), 0, pW(18), 0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: new DecorationImage(image: NetworkImage("${widget.itemData.details["url"]}")),
                ),
              ),

              // ),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(4)),
                child: Text(
                  "${widget.itemData.details["name"]}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(0xFF2B3B47),
                    fontWeight: FontWeight.w500,
                    fontSize: pH(15),
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: pH(8)),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(6), 0, pW(6), 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "₹${widget.itemData.details["cost"]}",
                            style: TextStyle(
                              color: Color(0xFFFF5352),
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          Text(
                            "₹${widget.itemData.details["mrp"]}",
                            style: TextStyle(
                              color: Color(0xFFB5B5B5),
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 15,
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ],
                      ),
                    ), //Your widget here,
                  ),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: pH(9)),
                    child: SizedBox(
                      height: pH(22),
                      width: pW(136),
                      child: RaisedButton(
                        onPressed: int.parse(widget.itemData.details["quantity"])==0?null:(){
                          addToCart();
                        },
                        disabledColor: Colors.grey,
                        child: int.parse(widget.itemData.details["quantity"])==0?Text(
                          "Out Of Stock",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: pH(12),
                            fontStyle: FontStyle.normal,
                            fontFamily: "Montserrat",
                          ),
                        ):Text(
                          _addedToCart?"Added to Cart":"Add to Cart",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: pH(12),
                            fontStyle: FontStyle.normal,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        color:  _addedToCart?Colors.green:Color(0xFF36A9CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                        //onPressed: onPressed,
                      ),
                    ), //Your widget here,
                  ),
                ),
              ),
              /*Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        child: SizedBox(
                          height: pH(19),
                          width: pW(136),
                          child: RaisedButton(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontSize: pH(12),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            color: Color(0xFF36A9CC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2),
                              ),
                            ),
                            //onPressed: onPressed,
                          ),
                        ),
                      )
                    ],
                  )*/
              /*Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                            SizedBox(
                              height: pH(19),
                              width: pW(136),
                              child: RaisedButton(
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w500,
                                    fontSize: pH(12),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                color: Color(0xFF36A9CC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                ),
                                //onPressed: onPressed,
                              ),
                            ),

                      ],
                    ),
                  )*/
            ],
          ),
        ),
      ),
    );
  }
}
