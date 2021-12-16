import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/delete--vets/petCareWidgetAssigner.dart';

class OverlayMaker {
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;
  BuildContext context;
  OverlayData overlayData;

  OverlayMaker({this.context, this.overlayData}) {
    this._overlayState = Overlay.of(this.context);
    this._overlayState.widget.createState();
    this._overlayEntry = createOverlayEntry();
  }
  insert() {
    _overlayState.insert(_overlayEntry);
  }

  OverlayEntry createOverlayEntry() {
    double pH(double height) {
      return MediaQuery.of(context).size.height * (height / 896);
    }

    double pW(double width) {
      return MediaQuery.of(context).size.width * (width / 414);
    }

    print(overlayData.options);
    List<bool> isCheck = [];
    overlayData.options.forEach((element) {
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
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(40), 0, 0),
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
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(30), 0, 0),
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
                              int optionsInd = isCheck.indexOf(true);
                              if (optionsInd == -1) return;
                              print(overlayData.options[optionsInd]);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) =>
                                    PetCareWidgetAssigner.assign(overlayData: overlayData, type: "vet",title: overlayData.options[optionsInd]),
                                ),
                              );

                              _overlayEntry.remove();
                              _overlayEntry = null;
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Color(0xFFFF5352), border: Border.all(color: Color(0xFFFF5352), width: 2), shape: BoxShape.circle),
                              child: new Icon(
                                Icons.chevron_right,
                                size: pH(60),
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
              isCheck[j] = !isCheck[j];
            } else {
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
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFFFFFFFF),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(35), 0, pH(35)),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(26), 0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: pW(25),
                              height: pW(25),
                              decoration: BoxDecoration(
                                  color: isCheck[i] == true ? Color(0xFFFF5352) : Colors.transparent,
                                  border: Border.all(color: Color(0xFFFF5352), width: 2),
                                  shape: BoxShape.circle),
                            )
                        ),
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
