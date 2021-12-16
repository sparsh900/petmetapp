import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/groomer.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/sign_in/sign_in_button.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/common_widgets/time_and_date_selector.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

import '../home_page_skeleton.dart';

class InnerGPage extends StatefulWidget {
  InnerGPage({@required this.groomerData, @required this.database, @required this.pet});
  final Groomer groomerData;
  final Database database;
  final Pet pet;
  InnerGPageState createState() => InnerGPageState();
}

class InnerGPageState extends State<InnerGPage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  String _packageSelected = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
          child: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            leading: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, pH(8), 0, 0),
              child: new IconButton(
                icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, pH(8), 0, 0),
              child: Text(
                widget.groomerData.clinicName,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 15,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: pH(285),
                        alignment: Alignment.topLeft,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: NetworkImage(
                              widget.groomerData.imagePath ??
                                  "https://cdn5.vectorstock.com/i/1000x1000/05/19/veterinary-building-facade-with-animals-vector-20510519.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          height: pH(20),
                          width: pW(414),
                          padding: EdgeInsetsDirectional.fromSTEB(pW(19), pH(10), 0, pH(8)),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(18),
                                  bottomLeft: Radius.circular(18)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(pW(19), 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(0, pH(18), 0, pH(19)),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(10)),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(pW(1), 0, 0, 0),
                                      child: Text(
                                        widget.groomerData.Name,
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
                              padding: EdgeInsetsDirectional.fromSTEB(0, pH(11), 0, pH(19)),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(10)),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(pW(1), 0, 0, 0),
                                      child: Text(
                                        widget.groomerData.Address,
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
                            ListView.builder(
                              itemCount: widget.groomerData.packages.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    if (_packageSelected == widget.groomerData.packages[index]["packageName"])
                                      _packageSelected = "";
                                    else
                                      _packageSelected = widget.groomerData.packages[index]["packageName"];
                                  });
                                },
                                child: Padding(
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
                                                widget.groomerData.packages[index]["packageName"].toString().toUpperCase(),
                                                style: TextStyle(
                                                    color: Color(0xFF36A9CC),
                                                    fontWeight: FontWeight.w600,
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
                                                        " ₹${widget.groomerData.packages[index]["cost"]} ",
                                                        //textAlign: TextAlign.right,
                                                        style: TextStyle(
                                                          color: Color(0xFF36A9CC),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: pH(24),
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
                                              children: _buildBulletPoints(widget.groomerData.packages[index]["facilities"]),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(22), 0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  width: pW(20),
                                                  height: pW(20),
                                                  decoration: BoxDecoration(
                                                      // color: _packageSelected == widget.groomerData.packages[index]["packageName"]
                                                      //     ? Color(0xFF36A9CC)
                                                      //     : Colors.transparent,
                                                      border: Border.all(color: Color(0xFF36A9CC), width: 2),
                                                      shape: BoxShape.circle),
                                                  child: Align(
                                                      alignment: Alignment.center,
                                                      child: Container(
                                                        width: pW(8),
                                                        height: pW(8),
                                                        decoration: BoxDecoration(
                                                            color: _packageSelected == widget.groomerData.packages[index]["packageName"] ? Color(0xFF36A9CC) : Colors.transparent,
                                                            shape: BoxShape.circle),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        widget.groomerData.isHomeVisit
                                            ? Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(pW(26), pH(16), pW(17), pH(7)),
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: Text(
                                                    "₹${widget.groomerData.packages[index]["homeVisitCharges"]} home visit charges extra",
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
                              ),
                            ),
                            SizedBox(
                              height: pH(10),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  if(_packageSelected==""){
                    ShowErrorDialog.show(context: context,message: "Please select a package",title: "Select one");
                    return;
                  }
                  _showBottomSheet(context);
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(10), pW(20), pH(18)),
                  child: Container(
                    height: pH(50),
                    decoration: BoxDecoration(
                        color: Color(0xFF36A9CC),
                      borderRadius: BorderRadius.circular(pH(60))
                    ),
                    child: Center(child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(0), pH(11), pW(0), pH(12)),
                      child: Text("Confirm Booking",
                        style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 4,
                        fontSize: pH(24)
                      ),),
                    )),
                  ),
                ),
              ),
            ),
            //BookAppointmentButton(database: widget.database,doctorId: widget.vetData.id,pet: widget.pet,contextPrevious: context,),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBulletPoints(String facilities) {
    List<String> bulletsInfo = facilities.split(".");
    return bulletsInfo
        .map((e) => e!=""?Padding(
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
            ):Container(height: 0,))
        .toList();
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: widget.groomerData.isHomeVisit && widget.groomerData.isVisitClinic ? 220 : 170,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(10), pW(20), pH(18)),
          child: Column(
            children: [
              Container(
                height: pH(50),
                decoration: BoxDecoration(
                    color: Color(0xFF36A9CC),
                    borderRadius: BorderRadius.circular(pH(60))
                ),
                child: Center(child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(pW(0), pH(11), pW(0), pH(12)),
                  child: Text("Proceed to Payment",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 4,
                        fontSize: pH(24)
                    ),),
                )),
              ),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.groomerData.isVisitClinic?SignInButton(
                          text: 'Visit Clinic',
                          color: Colors.white,
                          textColor: Colors.black,
                          icon: Icons.home,
                          height: 45,
                          iconSize: 30,
                          textSize: 20,
                          onPressed: () => _showVisitClinicSheet(context),
                        ):Container(height:0),
                        widget.groomerData.isHomeVisit?SignInButton(
                          text: 'Vet Home Visit',
                          color: Colors.white,
                          textColor: Colors.black,
                          icon: MyFlutterApp.doctor,
                          height: 45,
                          iconSize: 30,
                          textSize: 20,
                          onPressed: () {
                            if (checkUserAns) {
                              _showHomeVisitSheet(context);
                            } else {
                              ShowErrorDialog.show(
                                  context: context,
                                  title: 'No Addresses Found',
                                  message:
                                  'Please update your profile to continue');
                            }
                          },
                        ):Container(height: 0,),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showVisitClinicSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'CHOOSE TIME OF VISIT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TimeAndDateSelector(
                  mode: 'VisitClinic',
                  database: widget.database,
                  doctorId: widget.groomerData.id,
                  pet: widget.pet,
                  isGroomer: true,
                  packageName: _packageSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHomeVisitSheet(BuildContext context) async {
    UserData user = await widget.database.getUserData();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 500,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'CHOOSE TIME FOR HOME VISIT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                user.address,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TimeAndDateSelector(
                  mode: 'HomeVisit',
                  database: widget.database,
                  doctorId: widget.groomerData.id,
                  pet: widget.pet,
                  isGroomer: true,
                  packageName: _packageSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

