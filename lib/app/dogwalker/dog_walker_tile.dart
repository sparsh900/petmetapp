import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/dogWalkerPackage.dart';

class DogWalkerListTile extends StatefulWidget {
  DogWalkerListTile(
      {@required this.package,
      @required this.updatePackage,
      @required this.selectedPackage});
  final DogWalkerPackage package;
  final ValueChanged<DogWalkerPackage> updatePackage;
  final DogWalkerPackage selectedPackage;
  @override
  _DogWalkerListTileState createState() => _DogWalkerListTileState();
}

class _DogWalkerListTileState extends State<DogWalkerListTile> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(25)),
      child: GestureDetector(
        onTap: () {
          widget.updatePackage(widget.package);
        },
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
                        padding:
                            EdgeInsetsDirectional.fromSTEB(pW(4), pH(20), 0, 0),
                        child: Text("•  ${widget.package.description}",
                            style: new TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                              fontSize: pH(15),
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            )),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("₹ ${widget.package.cost}",
                          style: new TextStyle(
                            color: Color(0xFF36A9CC),
                            fontWeight: FontWeight.w600,
                            fontSize: pH(20),
                            fontStyle: FontStyle.normal,
                            fontFamily: "Montserrat",
                          )),
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0, pH(18), pW(4), 0),
                          child: Container(
                            width: pW(18),
                            height: pW(18),
                            decoration: BoxDecoration(
                                color: (widget.selectedPackage == null
                                            ? ''
                                            : widget.selectedPackage.id) ==
                                        widget.package.id
                                    ? Color(0xFF36A9CC)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: Color(0xFF36A9CC),
                                  width: 2,
                                ),
                                shape: BoxShape.circle),
                          ))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
