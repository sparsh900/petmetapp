import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/groomer.dart';
import 'package:petmet_app/main.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowGroomerPage extends StatefulWidget {
  ShowGroomerPage({@required this.groomerData,@required this.packageName});
  final Groomer groomerData;
  final String packageName;
  @override
  ShowGroomerPageState createState() => ShowGroomerPageState();
}

class ShowGroomerPageState extends State<ShowGroomerPage> {

  Map<String,dynamic> package;
  @override
  void initState(){
    super.initState();
    getPackage();
  }

  getPackage(){
    int index=widget.groomerData.packages.indexWhere((element){
        return element["packageName"]==widget.packageName;
    });
    package = widget.groomerData.packages[index];
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  void _launchMaps() async {
    var latitude=widget.groomerData.locationData['latitude'];
    var longitude=widget.groomerData.locationData['longitude'];

    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
          child: AppBar(
            backgroundColor: petColor,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back,
                  size: 22, color: Color(0xFFFFFFFF)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "${widget.groomerData.clinicName}",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: pH(285),
              alignment: Alignment.bottomLeft,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image:  NetworkImage(
                    widget.groomerData.imagePath ?? "https://cdn5.vectorstock.com/i/1000x1000/05/19/veterinary-building-facade-with-animals-vector-20510519.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                //height: pH(39),
                width: pW(414),
                color: Color.fromRGBO(66, 66, 66, 0.65),
                padding:
                EdgeInsetsDirectional.fromSTEB(pW(19), pH(10), 0, pH(8)),
                child: new Text("${widget.groomerData.clinicName}",
                    style: new TextStyle(
                      //backgroundColor: Color.fromRGBO(66, 66, 66, 0.65),
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(22),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    )),
              ),
            ),
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(pW(19), 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0, pH(18), 0, pH(19)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  width: 0.6,
                                  color: Color(0xFF868686),
                                ))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, pH(10)),
                                child: Text(
                                  "Name: ",
                                  style: TextStyle(
                                    color: Color(0xFF36A9CC),
                                    fontWeight: FontWeight.normal,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    pW(1), 0, 0, 0),
                                child: Text(
                                  "${widget.groomerData.Name}",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.normal,
                                    fontSize: pH(18),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0, pH(11), 0, pH(19)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  width: 0.6,
                                  color: Color(0xFF868686),
                                ))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, pH(10)),
                                child: Text(
                                  "Address:",
                                  style: TextStyle(
                                    color: Color(0xFF36A9CC),
                                    fontWeight: FontWeight.normal,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    pW(1), 0, 0, 0),
                                child: Text(
                                  "${widget.groomerData.Address}",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.normal,
                                    fontSize: pH(18),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, pH(20), pW(22), pH(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color((0xFFFFFFFF)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(pW(22), pH(19), 0, pH(16)),
                                    child: Text(
                                      package["packageName"].toUpperCase(),
                                      style: TextStyle(
                                          color: Color(0xFFFF5352),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(22),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                          wordSpacing: 1.2),overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  /**/
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, pH(19), pW(15), 0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              " ₹${package["cost"]} ",
                                              //textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF36A9CC),
                                                fontWeight: FontWeight.w400,
                                                fontSize: pH(23),
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Montserrat",
                                              ),
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  _buildBulletPoints(package["facilities"]),
                                  ),
                                ],
                              ),
                              widget.groomerData.isHomeVisit
                                  ? Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(pW(26), pH(16), pW(17), pH(7)),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "₹${package["homeVisitCharges"]} home visit charges extra",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: pH(13),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                              )
                                  : Container(
                                height: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsetsDirectional.fromSTEB(
                      //       0, pH(11), 0, pH(19)),
                      //   decoration: BoxDecoration(
                      //       border: Border(
                      //           bottom: BorderSide(
                      //             width: 0.6,
                      //             color: Color(0xFF868686),
                      //           ))),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.stretch,
                      //     children: [
                      //       Container(
                      //         child: Padding(
                      //           padding: EdgeInsetsDirectional.fromSTEB(
                      //               0, 0, 0, pH(10)),
                      //           child: Text(
                      //             "About:",
                      //             style: TextStyle(
                      //               color: Color(0xFF36A9CC),
                      //               fontWeight: FontWeight.normal,
                      //               fontSize: pH(14),
                      //               fontStyle: FontStyle.normal,
                      //               fontFamily: "Montserrat",
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         child: Padding(
                      //           padding: EdgeInsetsDirectional.fromSTEB(
                      //               pW(1), 0, 0, 0),
                      //           child: Text(
                      //             "${widget.groomerData.experience}",
                      //             style: TextStyle(
                      //               color: Color(0xFF000000),
                      //               fontWeight: FontWeight.normal,
                      //               fontSize: pH(18),
                      //               fontStyle: FontStyle.normal,
                      //               fontFamily: "Montserrat",
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            RaisedButton(
              color: Color(0xFFFF5352),
              onPressed: _launchMaps,
              child: Container(
                height: 56,
                width: 414,
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Text(
                  "GET DIRECTIONS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _buildBulletPoints(String facilities) {
    List<String> bulletsInfo = facilities.split(".");
    return bulletsInfo
        .map((e) => Padding(
      padding: EdgeInsetsDirectional.fromSTEB(pW(26), 0, 0, pH(6)),
      child: Text(
        "•   $e",
        style: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.w400,
          fontSize: pH(17),
          fontStyle: FontStyle.normal,
          fontFamily: "Montserrat",
        ),
      ),
    ))
        .toList();
  }

}


