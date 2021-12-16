import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/myDogWalkerPackage.dart';
import 'package:petmet_app/main.dart';

class MyDogWalkerListTile extends StatefulWidget {
  MyDogWalkerListTile({@required this.package});
  final MyDogWalkerPackage package;
  @override
  _MyDogWalkerListTileState createState() => _MyDogWalkerListTileState();
}

class _MyDogWalkerListTileState extends State<MyDogWalkerListTile> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  int _calculateDaysLeft() {
    String dateStringNew = widget.package.id.substring(0, 10) +
        ' ' +
        widget.package.id.substring(11);
    DateTime date = DateTime.parse(dateStringNew);
    DateTime dateEnd =
        date.add(Duration(days: (30 * widget.package.durationInMonths)));
    final date2 = DateTime.now();
    final difference = dateEnd.difference(date2);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(11)),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xFFFFFFFF),
                boxShadow: [
                  new BoxShadow(
                      color: Color.fromRGBO(124, 124, 124, 0.25),
                      blurRadius: 10,
                      offset: Offset(0, 0)),
                ],
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    pW(23), pH(19), pW(15), pH(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            widget.package.durationInMonths == 1
                                ? "${widget.package.durationInMonths} MONTH"
                                : "${widget.package.durationInMonths} MONTHS",
                            style: new TextStyle(
                              color: Color(0xFF36A9CC),
                              fontWeight: FontWeight.w600,
                              fontSize: pH(20),
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(4), pH(20), 0, 0),
                          child: Text("•  ${widget.package.description}",
                              style: new TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: pH(15),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              )),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(4), pH(20), 0, 0),
                          child: Text("•  Pet - ${widget.package.petName}",
                              style: new TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: pH(15),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              )),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(4), pH(20), 0, 0),
                          child: Text("•  Time - ${widget.package.time}",
                              style: new TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: pH(15),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              )),
                        ),
                      ],
                    ),
                    Text("₹ ${widget.package.cost}",
                        style: new TextStyle(
                          color: Color(0xFF36A9CC),
                          fontWeight: FontWeight.w600,
                          fontSize: pH(20),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ))
                  ],
                ),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Text(
                'Expires in ${_calculateDaysLeft()} Days',
                style: TextStyle(
                  fontSize: 14,
                  color: metColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
