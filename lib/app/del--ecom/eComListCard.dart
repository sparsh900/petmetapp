import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petmet_app/app/del--shop/show_item_page.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/services/database.dart';

import 'blocs/eCom_bloc.dart';

class EComListCard extends StatefulWidget {
  EComListCard({@required this.itemData, @required this.database});
  final Item itemData;
  final Database database;
  @override
  _EComListCardState createState() => _EComListCardState();
}

class _EComListCardState extends State<EComListCard> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EComBloc>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: bloc,
              child: ShowItemPage(itemData: widget.itemData, database: widget.database),
            );
          }),
        );
      },
      child: Container(
        height: pH(230),
        width: pW(155),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(0xFFFFFFFF),
          boxShadow: [
            new BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: pH(7), offset: Offset(0, 0)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: pH(105),
              width: pW(98),
              padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(8), pW(18), 0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: new DecorationImage(image: NetworkImage("${widget.itemData.details["url"]}")),
              ),
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, pH(4), 0, pH(4)),
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
                    padding: EdgeInsetsDirectional.fromSTEB(pW(15), 0, pW(15), 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "₹${widget.itemData.details["cost"]}",
                          style: TextStyle(
                            color: Color(0xFFFF5352),
                            fontWeight: FontWeight.w600,
                            fontSize: pW(24),
                            fontStyle: FontStyle.normal,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        Text(
                          "₹1250",
                          style: TextStyle(
                            color: Color(0xFFB5B5B5),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            fontSize: pW(16),
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
            /*Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: SizedBox(
                            height: pH(22),
                            width: pW(136),
                            child: RaisedButton(
                              disabledColor: Color(0xFF36A9CC),
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
                        ),
                      )

                    ],
                  ),*/
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: pH(9)),
                  child: Container(
                    height: pH(24),
                    width: pW(136),
                    child: RaisedButton(
                      onPressed: () {},
                      disabledColor: Color(0xFF36A9CC),
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
    );
  }
}
