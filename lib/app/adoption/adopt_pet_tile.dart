import 'package:flutter/material.dart';
import 'package:petmet_app/app/adoption/inner_adoption_page.dart';
import 'package:petmet_app/app/home/models/adoption.dart';
import 'package:petmet_app/services/database.dart';

class AdoptPetTile extends StatefulWidget {
  AdoptPetTile({@required this.adoptPet,@required this.database});
  final AdoptPet adoptPet;
  final Database database;
  @override
  _AdoptPetTileState createState() => _AdoptPetTileState();
}

class _AdoptPetTileState extends State<AdoptPetTile> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(20)),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => InnerAdoptionPage(adoptPet: widget.adoptPet,database: widget.database),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Color(0xFFFFFFFF),
            boxShadow: [
              new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.14),
                  blurRadius: 6,
                  offset: Offset(0, 0)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    pW(15), pH(17), pW(20), pH(17)),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: pH(138),
                      width: pW(130),
                      alignment: Alignment.bottomCenter,
                      decoration: new BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(6),
                        image: new DecorationImage(
                          image: NetworkImage(
                            widget.adoptPet.image[0],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        //height: pH(39),
                        width: pW(130),
                        decoration: BoxDecoration(
                            color:
                            Color.fromRGBO(0, 0, 0, 0.40),
                            borderRadius: BorderRadius.only(
                                bottomLeft:
                                Radius.circular(6),
                                bottomRight:
                                Radius.circular(6))),
                        padding:
                        EdgeInsetsDirectional.fromSTEB(
                            0, pH(1), 0, pH(2)),
                        child: new Text(widget.adoptPet.name,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              //backgroundColor: Color.fromRGBO(66, 66, 66, 0.65),
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w400,
                              fontSize: pH(22),
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(22), 0, 0, 0),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional
                                .fromSTEB(
                                0, pH(8), 0, pH(13)),
                            child: Row(
                              children: [
                                Text("Category:",
                                    style: new TextStyle(
                                      color:
                                      Color(0xFF868686),
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: pH(16),
                                      fontStyle:
                                      FontStyle.normal,
                                      fontFamily:
                                      "Montserrat",
                                    )),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional
                                      .fromSTEB(pW(10), 0,
                                      0, 0),
                                  child: Text(widget.adoptPet.category,
                                      style: new TextStyle(
                                        color:
                                        Color(0xFF000000),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: pH(20),
                                        fontStyle:
                                        FontStyle.normal,
                                        fontFamily:
                                        "Montserrat",
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional
                                .fromSTEB(0, 0, 0, pH(13)),
                            child: Row(
                              children: [
                                Text("Breed:",
                                    style: new TextStyle(
                                      color:
                                      Color(0xFF868686),
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: pH(16),
                                      fontStyle:
                                      FontStyle.normal,
                                      fontFamily:
                                      "Montserrat",
                                    )),
                                Container(
                                  width: pW(140),
                                  padding:
                                  EdgeInsetsDirectional
                                      .fromSTEB(pW(10), 0,
                                      0, 0),
                                  child: Text(widget.adoptPet.breed,
                                      overflow: TextOverflow
                                          .ellipsis,
                                      maxLines: 1,
                                      style: new TextStyle(
                                        color:
                                        Color(0xFF000000),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: pH(20),
                                        fontStyle:
                                        FontStyle.normal,
                                        fontFamily:
                                        "Montserrat",
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional
                                .fromSTEB(0, 0, 0, pH(13)),
                            child: Row(
                              children: [
                                Text("Color:",
                                    style: new TextStyle(
                                      color:
                                      Color(0xFF868686),
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: pH(16),
                                      fontStyle:
                                      FontStyle.normal,
                                      fontFamily:
                                      "Montserrat",
                                    )),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional
                                      .fromSTEB(pW(10), 0,
                                      0, 0),
                                  child: Text(widget.adoptPet.color,
                                      style: new TextStyle(
                                        color:
                                        Color(0xFF000000),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: pH(20),
                                        fontStyle:
                                        FontStyle.normal,
                                        fontFamily:
                                        "Montserrat",
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional
                                .fromSTEB(0, 0, 0, 0),
                            child: Row(
                              children: [
                                Text("Age:",
                                    style: new TextStyle(
                                      color:
                                      Color(0xFF868686),
                                      fontWeight:
                                      FontWeight.w400,
                                      fontSize: pH(16),
                                      fontStyle:
                                      FontStyle.normal,
                                      fontFamily:
                                      "Montserrat",
                                    )),
                                Padding(
                                  padding:
                                  EdgeInsetsDirectional
                                      .fromSTEB(pW(10), 0,
                                      0, 0),
                                  child: Text("${widget.adoptPet.age} Years",
                                      style: new TextStyle(
                                        color:
                                        Color(0xFF000000),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: pH(20),
                                        fontStyle:
                                        FontStyle.normal,
                                        fontFamily:
                                        "Montserrat",
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment:
                        FractionalOffset.centerRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: pH(24),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
