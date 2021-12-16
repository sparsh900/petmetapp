import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/groomer.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class InnerGBackupPage extends StatefulWidget {
  InnerGBackupPage({@required this.groomerData, @required this.database});
  final Groomer groomerData;
  final Database database;
  InnerGBackupPageState createState() => InnerGBackupPageState();
}

class InnerGBackupPageState extends State<InnerGBackupPage> {

  final Pet pet = globalCurrentPet;
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  bool checkBoxValue = false;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              "ORTHO VET CLINIC",
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
                    "https://cdn5.vectorstock.com/i/1000x1000/05/19/veterinary-building-facade-with-animals-vector-20510519.jpg",
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
                child: new Text("ORTHO VET CLINIC",
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
                                  "Dr. Arvind Goyal",
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
                                  "SCF Number 7, Street Number 2, Sector 15,Chandigarh",
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
                            //border: new Border.all(width: 1.0, color: Color(0xFFFFFFFF)),
                            borderRadius: BorderRadius.circular(4),
                            /*boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color.fromRGBO(124,124,124,0.25),
                                offset: Offset(1.0, 6.0),
                                blurRadius: 40.0,
                              ),
                            ],*/
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(pW(22), pH(19), 0, pH(16)),
                                    child: Text(
                                      "SPA PACKAGE",
                                      style: TextStyle(
                                        color: Color(0xFFFF5352),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pH(22),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
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
                                              " ₹950 ",
                                              //textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(0xFF36A9CC),
                                                fontWeight: FontWeight.w400,
                                                fontSize: pH(23),
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Montserrat",
                                              ),
                                            ),
                                          )
                                      ),

                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(pW(26), 0, 0, pH(6)),
                                        child: Text(
                                          "•   Bathing and Blow Dry",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w400,
                                            fontSize: pH(17),
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(pW(26), 0, 0, pH(6)),
                                        child: Text(
                                          "•   Body Massage",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w400,
                                            fontSize: pH(17),
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(pW(26), 0, 0, pH(6)),
                                        child: Text(
                                          "•   Puff off Fragrance",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w400,
                                            fontSize: pH(17),
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(pW(26), 0, 0, pH(6)),
                                        child: Text(
                                          "•   Paw Therapy",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontWeight: FontWeight.w400,
                                            fontSize: pH(17),
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(22), 0),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: ()  {
                                            setState(() {
                                              checkBoxValue1 =
                                              !checkBoxValue1;
                                              checkBoxValue2 =
                                              !checkBoxValue2;
                                              checkBoxValue3 =
                                              !checkBoxValue3;
                                              super.initState();
                                            });
                                          },

                                          child: Container(
                                            width: pW(25),
                                            height: pW(25),
                                            decoration: BoxDecoration(
                                                color: checkBoxValue1 ==
                                                    true ? Color(
                                                    0xFFFF5352) : Colors
                                                    .transparent,
                                                border: Border.all(
                                                    color: Color(
                                                        0xFFFF5352),
                                                    width: 2
                                                ),
                                                shape: BoxShape.circle
                                            ),
                                          ),

                                        )
                                      /*new Checkbox(value: checkBoxValue1,
                                                      activeColor: Color(0xFFFF5352),
                                                      onChanged:(bool newValue){
                                                        setState(() {
                                                          checkBoxValue1 = newValue;
                                                        });
                                                      }),*/
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(pW(26), pH(16), pW(17), pH(7)),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "₹100 home visit charges extra",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: pH(13),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            //BookAppointmentButton(database: widget.database,doctorId: widget.vetData.id,pet: widget.pet,contextPrevious: context,),
          ],
        ),
      ),
    );
  }
}

