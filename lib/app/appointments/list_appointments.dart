import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/main.dart';

class AppointmentListPage extends StatefulWidget {
  //InnerVetPage({@required this.vetData, @required this.database,@required this.pet});
  //final Vet vetData;
  //final Database database;
  //final Pet pet;
  @override
  AppointmentListPageState createState() => AppointmentListPageState();
}

class AppointmentListPageState extends State<AppointmentListPage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<String> entries = <String>[
    "Dr. Arvind Goyal",
    "Dr. Arvind Goyal",
    "Dr. Arvind Goyal",
    "Dr. Arvind Goyal",
    "Dr. Arvind Goyal",
    "Dr. Arvind Goyal"
  ];
  final List<String> role = <String>[
    "groomer",
    "dog and cat specialist",
    "groomer",
    "groomer",
    "dog and cat specialist",
    "groomer"
  ];
  final List<int> colorCodes = <int>[100, 200, 300, 400, 500, 600];
  final List<int> condition = <int>[1, 2, 3, 4, 5, 6];
  final List<bool> button = <bool>[false, false, false, false, false, false];
  /*bool button1=false;
  bool button2=false;
  bool button3=false;*/

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
              "MY APPOINTMENTS",
              style: TextStyle(
                fontSize: pH(24),
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    button[index] = true;
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Color(0xFF868686),
                      width: 0.5,
                    ))),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(20), pH(35), 0, pH(12)),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, pW(12), pH(6.5)),
                                  child: Text(
                                    "${entries[index]}",
                                    style: TextStyle(
                                      fontSize: pH(22),
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                                if ("${condition[index]}" == "1")
                                  Text(
                                    "•   PENDING",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFFB017F9),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                if ("${condition[index]}" == "2")
                                  Text(
                                    "•   REQUEST ACCEPTED",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFFB017F9),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                if ("${condition[index]}" == "3")
                                  Text(
                                    "•   COMPLETE",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFF03A300),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                if ("${condition[index]}" == "4")
                                  Text(
                                    "•   REQUEST DECLINED",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFFFF5352),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                if ("${condition[index]}" == "5")
                                  Text(
                                    "•   CANCELLED",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFFFF5352),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                if ("${condition[index]}" == "6")
                                  Text(
                                    "•   BOOKING CONFIRMED",
                                    style: TextStyle(
                                      fontSize: pH(17),
                                      color: Color(0xFF03A300),
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, pH(11)),
                              child: Text(
                                "${role[index]}",
                                style: TextStyle(
                                  fontSize: pH(15),
                                  color: Color(0xFF868686),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, pH(7)),
                              child: Text(
                                "7 october, 2020 (Sunday)",
                                style: TextStyle(
                                  fontSize: pH(17),
                                  color: Color(0xFFB5B5B5),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, pH(18)),
                              child: Text(
                                "10:00 PM (IST)",
                                style: TextStyle(
                                  fontSize: pH(17),
                                  color: Color(0xFFB5B5B5),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          if (button[index] == true &&
                              "${condition[index]}" == "2")
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ButtonTheme(
                                  minWidth: pW(198),
                                  height: pH(32),
                                  child: RaisedButton(
                                    color: Color(0xFF03A300),
                                    child: Text(
                                      'Proceed to Pay ₹950',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: pH(17)),
                                    ),
                                    onPressed: () {
                                      print('You tapped on RaisedButton');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          if (button[index] == true &&
                              "${condition[index]}" == "4")
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ButtonTheme(
                                  minWidth: pW(198),
                                  height: pH(32),
                                  child: RaisedButton(
                                    color: Color(0xFFB017F9),
                                    child: Text(
                                      'Choose any other Time',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: pH(17)),
                                    ),
                                    onPressed: () {
                                      print('You tapped on RaisedButton');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          if (button[index] == true &&
                              "${condition[index]}" == "6")
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ButtonTheme(
                                  minWidth: pW(198),
                                  height: pH(32),
                                  child: RaisedButton(
                                    color: Color(0xFF03A300),
                                    child: Text(
                                      'Locate Clinic',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: pH(17)),
                                    ),
                                    onPressed: () {
                                      print('You tapped on RaisedButton');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, pW(22), 0),
                              child: Text(
                                "10 mins ago",
                                style: TextStyle(
                                  fontSize: pH(12),
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            }),
      ),
    );
  }
}
