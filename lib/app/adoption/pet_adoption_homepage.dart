import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:petmet_app/app/adoption/adopt_pet_tile.dart';
import 'package:petmet_app/app/home/models/adoption.dart';
import 'package:flutter/painting.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/app/adoption/add_pet_adoption.dart';
import 'package:petmet_app/services/list_items_builder2.dart';

class AdoptionHomepage extends StatefulWidget {
  AdoptionHomepage({@required this.database, @required this.uid});
  final Database database;
  final String uid;
  @override
  _AdoptionHomepageState createState() => _AdoptionHomepageState();
}

class _AdoptionHomepageState extends State<AdoptionHomepage> {
  @override
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  void initState() {
    super.initState();
    //final Database database = Provider.of<Database>(context, listen: false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "ADOPT A PET",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(pW(10), pH(18), pW(10), 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
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
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      pW(15), pH(14), pW(16), pH(14)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => AdoptionForm(
                                database: widget.database, uid: widget.uid)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: pH(76),
                          width: pW(70),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFF0F0F0),
                          ),
                          child: Center(
                            child: Text(
                              "+",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w700,
                                fontSize: pH(28),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(pW(25), 0, 0, 0),
                          child: Text(
                            "Add a Pet for adoption",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                              fontSize: pH(18),
                              fontStyle: FontStyle.normal,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, pH(36), 0, pH(16)),
                child: Text(
                  "MY PETS",
                  style: TextStyle(
                    color: Color(0xFF36A9CC),
                    fontWeight: FontWeight.w500,
                    fontSize: pH(22),
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<List<AdoptPet>>(
                  stream: widget.database
                      .myAdoptPetsStream(), // define stream coming from database , make sure it's type is List<SlotModel>
                  builder: (context, snapshot) {
                    return ListItemBuilder(
                        neverScrollable: true,
                        showDivider: false,
                        snapshot: snapshot,
                        itemBuilder: (context, adoptPet) {
                          if (adoptPet != null)
                            return AdoptPetTile(
                                adoptPet: adoptPet, database: widget.database);
                          else
                            return Container();
                        });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, pH(36), 0, pH(16)),
                child: Text(
                  "ADOPT A PET",
                  style: TextStyle(
                    color: Color(0xFF36A9CC),
                    fontWeight: FontWeight.w500,
                    fontSize: pH(22),
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<List<AdoptPet>>(
                  stream: widget.database
                      .adoptPetsStream(), // define stream coming from database , make sure it's type is List<SlotModel>
                  builder: (context, snapshot) {
                    return ListItemBuilder(
                        neverScrollable: true,
                        showDivider: false,
                        snapshot: snapshot,
                        itemBuilder: (context, adoptPet) {
                          if (adoptPet != null)
                            return AdoptPetTile(
                                adoptPet: adoptPet, database: widget.database);
                          else
                            return Container();
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
