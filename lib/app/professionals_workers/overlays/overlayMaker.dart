import 'package:flutter/material.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/app/home/home_page.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/services/database.dart';
import '../variantsAndConfig/widgetAssigner.dart';
import 'overlayData.dart';

class OverlayMaker {
  //received
  BuildContext context;
  OverlayData overlayData;

  //overlay
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;
  Database database;

  bool isInner;
  //constructor called to prepare state and ui
  OverlayMaker({@required this.context, @required this.overlayData, this.database, this.isInner = false}) {
    //creating overlay state
    this._overlayState = Overlay.of(this.context);
    this._overlayState.widget.createState();
    //creating and building overlay & ui
    this._overlayEntry = createOverlayEntry();
  }

  //called post widget build executed to insert entry on blank container
  insert() {
    _overlayState.insert(_overlayEntry);
  }

  dispose() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry createOverlayEntry() {
    if (overlayData.options == null) return null;

    double pH(double height) {
      return MediaQuery.of(context).size.height * (height / 896);
    }

    double pW(double width) {
      return MediaQuery.of(context).size.width * (width / 414);
    }

    List<bool> isCheck = [];
    overlayData.options.forEach((element) {
      //initial all radio are unselected
      isCheck.add(false);
    });

    return OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withOpacity(0.75),
        child: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(20), pW(22), pH(50)),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: new Icon(Icons.cancel_rounded, size: 40, color: Color(0xFFFFFFFF)),
                            onPressed: () {
                              if (isInner)
                                _overlayEntry.remove();
                              else {
                                globalNavBarController.index = 0;
                              }
                            }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(20), 0, pW(20), 0),
                      child: Text(
                        overlayData.heading,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Montserrat",
                          fontSize: pH(36),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Color(0xFFFFFFFF),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                      indent: pW(50),
                      endIndent: pW(50),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(70), 0, 0),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: overlayData.options.length,
                      itemBuilder: (context, index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          overlayTile(pW, pH, isCheck, index),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(40), 0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: pH(95),
                      child: Stack(alignment: Alignment.topRight, children: [
                        Positioned(
                          right: pW(30),
                          child: InkWell(
                            onTap: () {
                              //get which index was clicked
                              int optionsInd = isCheck.indexOf(true);
                              //if no index found nothing happens
                              if (optionsInd == -1) return;

                              // removing overlay
                              _overlayEntry.remove();
                              _overlayEntry = null;

                              // //navigating to desired page
                              // Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           WidgetAssigner.assign(overlayData: overlayData, category: overlayData.options[optionsInd]),
                              //     ),
                              //     ModalRoute.withName('/overlayVets')
                              // );

                              if (overlayData.profession == Professions.trainer.string) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => WidgetAssigner.assign(overlayData: overlayData, category: overlayData.options[optionsInd], database: database),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => WidgetAssigner.assign(overlayData: overlayData, category: overlayData.options[optionsInd]),
                                  ),
                                );
                              }
                              //
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xFF36A9CC), border: Border.all(color: Color(0xFF36A9CC), width: 2), shape: BoxShape.circle),
                              child: new Icon(
                                Icons.chevron_right,
                                size: pH(75),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  InkWell overlayTile(double pW(double width), double pH(double height), List<bool> isCheck, int i) {
    return InkWell(
      onTap: () {
        _overlayState.setState(() {
          for (int j = 0; j < isCheck.length; j++) {
            if (j == i) {
              //clicked radio value is reciprocated
              isCheck[j] = !isCheck[j];
            } else {
              //rest all are made false
              isCheck[j] = false;
            }
          }
        });
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(pW(20), 0, pW(20), 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Color(0xFFFFFFFF),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(21), 0, pH(20)),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(pW(33), 0, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              overlayData.options[i].toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: "Montserrat",
                                fontSize: pH(32),
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: Color(0xFF36A9CC),
                                letterSpacing: 1,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(26), 0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: pW(22),
                              height: pW(22),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: pW(12),
                                    height: pW(12),
                                    decoration: BoxDecoration(color: isCheck[i] == true ? Color(0xFFFF5352) : Colors.transparent, shape: BoxShape.circle),
                                  )),
                              decoration: BoxDecoration(
                                  //color: isCheck[i] == true ? Color(0xFFFF5352) : Colors.transparent,
                                  border: Border.all(color: Color(0xFFFF5352), width: 2),
                                  shape: BoxShape.circle),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
