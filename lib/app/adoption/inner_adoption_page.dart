import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:petmet_app/app/home/models/adoption.dart';
import 'package:petmet_app/common_widgets/custom_carousel.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class InnerAdoptionPage extends StatefulWidget {
  InnerAdoptionPage({@required this.adoptPet, @required this.database});
  final AdoptPet adoptPet;
  final Database database;
  @override
  _InnerAdoptionPageState createState() => _InnerAdoptionPageState();
}

class _InnerAdoptionPageState extends State<InnerAdoptionPage> {
  @override
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "PET PROFILE",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
          elevation: 2.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: pH(896),
              child: Stack(
                //fit: StackFit.expand,
                clipBehavior: Clip.none,
                overflow: Overflow.visible,
                children: [
                  CustomCarousel(
                    path:
                        "NOT NEEDED see TODO , inserted due to required", //TODO: make path obsolete change from home-screen improve performance
                    customHeight: pH(340),
                    fit: BoxFit.cover,
                    dotColor: metColor,
                    listOfURL: widget.adoptPet.image,
                  ),
                  Positioned(
                    top: pH(265),
                    left: 0,
                    right: 0,
                    child: Container(
                      //height: pH(896),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(0xFFFFFFFF)),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            pW(28), pH(26), pW(26), pH(120)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "${widget.adoptPet.name} (${widget.adoptPet.breed})",
                              maxLines: 2,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                fontSize: pH(30),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, pH(12), 0, pH(20)),
                              child: Text(
                                "${widget.adoptPet.gender}  .  ${widget.adoptPet.age} Years",
                                style: TextStyle(
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w400,
                                  fontSize: pH(15),
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  //width: pW(90),
                                  height: pH(100),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(72, 207, 248, 0.25),
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        pW(12), pH(17), pW(12), pH(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${widget.adoptPet.weight}Kg",
                                          style: TextStyle(
                                            color: Color(0xFF058FB9),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                        Text(
                                          "Weight",
                                          style: TextStyle(
                                            color: Color(0xFF058FB9),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      pW(20), 0, 0, 0),
                                  child: Container(
                                    //width: pW(90),
                                    height: pH(100),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 83, 82, 0.21),
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          pW(12), pH(17), pW(12), pH(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${widget.adoptPet.color}",
                                            style: TextStyle(
                                              color: Color(0xFFFF0301),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                          Text(
                                            "Color",
                                            style: TextStyle(
                                              color: Color(0xFFFF0301),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, pH(40), 0, pH(12)),
                              child: Text(
                                "Summary",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w600,
                                  fontSize: pH(20),
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ),
                            Text(
                              widget.adoptPet.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              ),
                            ),
                            if(widget.adoptPet.ownerId!=widget.database.getUid())
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, pH(50), 0, 0),
                              child: Container(
                                height: pH(56),
                                decoration: BoxDecoration(
                                    color: Color(0xFF36A9CC),
                                    borderRadius: BorderRadius.circular(pH(56))),
                                child: FlatButton(
                                  onPressed: () async {
                                    await widget.database.sendAdoptionRequest(
                                      ownerId: widget.adoptPet.ownerId,
                                      petId: widget.adoptPet.id,
                                    );
                                    await ShowErrorDialog.show(
                                      context: context,
                                      title: 'Adoption Request Sent',
                                      message: 'Please wait for reply.',
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, pH(12), 0, 11),
                                  color: Color(0xFF36A9CC),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(pH(56))),
                                  child: Text(
                                    'ADOPT',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: pH(20),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
