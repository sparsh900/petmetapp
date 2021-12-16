import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/adoption/pet_adoption_homepage.dart';
import 'package:petmet_app/app/dogwalker/selectpetdogwalker.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayData.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayMaterial.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/widgetAssigner.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../home_page_skeleton.dart';

class OtherHomePage extends StatefulWidget {
  @override
  _OtherHomePageState createState() => _OtherHomePageState();
}

class _OtherHomePageState extends State<OtherHomePage> {
  Database database;
  @override
  void initState() {
    super.initState();
    database = Provider.of<Database>(context, listen: false);
    if (globalNavBarController.getTileNavigator == 1) {
      Future.microtask(() => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OverlayMaterial(
              overlayData: OverlayData(
                  heading: "Where do you want to groom your pet?", options: [Filters.home.string, Filters.clinic.string], profession: Professions.petGroomer.string)))));
    } else if (globalNavBarController.getTileNavigator == 2) {
      Future.microtask(() => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WidgetAssigner.hostels(database: database),
          )));

      // Future.microtask(() => globalNavigatorKeys[TabItem.others].currentState.push(MaterialPageRoute(
      //       builder: (context) => WidgetAssigner.hostels(database: database),
      //     )));
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => WidgetAssigner.hostels(database: database),
      //       ));
      // });
    }

    // else if(globalNavBarController.getTileNavigator == 2){
    //   Future.microtask(() => Navigator.of(globalNavigatorKeys[TabItem.others].currentContext).push(
    //       MaterialPageRoute(
    //           builder: (context) =>  OverlayMaterial(
    //                       overlayData: OverlayData(
    //                           heading:
    //                           "Where do you want to train your pet?",
    //                           options: [
    //                             Filters.atMyHome.string,
    //                             Filters.atTrainingCentre.string,
    //                             Filters.online.string
    //                           ],
    //                           profession: Professions
    //                               .trainer.string)))
    //   ));
    // }
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(21), pH(25), pW(21), pH(35)),
            child: Wrap(
              spacing: pW(16),
              runSpacing: pH(18),
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  children: [
                    InkWell(
                      child: ImageTile("images/vet_b.png"),
                      onTap: () {
                        globalNavBarController.index = 1;
                      },
                      // onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context) => OverlayMaterial(overlayData: OverlayData(heading: "For what purpose are you looking for a Vet?",options:[Categories.consultation.string,Categories.deworming.string,Categories.vaccine.string],profession:Professions.vet.string)))),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Vet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                        child: ImageTile("images/grooming_b.png"),
                        onTap: () {
                          globalNavBarController.tileNavigator = 1;
                          globalNavBarController.navigatingTheOthers();
                          globalNavBarController.index = 3;
                        }
                        // Navigator.of(context).push(
                        // MaterialPageRoute(
                        //     builder: (context) => OverlayMaterial(
                        //         overlayData: OverlayData(
                        //             heading:
                        //             "Where do you want to groom your pet?",
                        //             options: [
                        //               Filters.home.string,
                        //               Filters.clinic.string
                        //             ],
                        //             profession: Professions
                        //                 .petGroomer
                        //                 .string)))),
                        ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Grooming",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      child: ImageTile("images/trainer_b.png"),
                      onTap: () {
                        // globalNavBarController.tileNavigator=2;
                        // globalNavBarController.navigatingTheOthers();
                        // globalNavBarController.index = 3;
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                            builder: (context) => OverlayMaterial(
                                database: database,
                                overlayData: OverlayData(
                                    heading: "Where do you want to train your pet?",
                                    options: [Filters.atMyHome.string, Filters.atTrainingCentre.string, Filters.online.string],
                                    profession: Professions.trainer.string))));
                      },
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Training",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (globalCurrentPet == null) {
                          ShowErrorDialog.show(context: context, title: 'No Pet Found', message: 'Please add a Pet to continue');
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => DogWalkerHomepage(
                                      database: database,
                                      uid: database.getUid(),
                                    )),
                          );
                        }
                      },
                      child: ImageTile("images/walker_b.png"),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Dog Walker",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (context) => AdoptionHomepage(database: database, uid: database.getUid()),
                      )),
                      child: ImageTile("images/adoption_b.png"),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Adoption",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        globalNavBarController.tileNavigator = 2;
                        globalNavBarController.navigatingTheOthers();
                        globalNavBarController.index = 3;
                      },
                      child: ImageTile("images/hostel_b.png"),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(12), 0, 0),
                      child: Text(
                        "Hostel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF272727),
                          fontWeight: FontWeight.w500,
                          fontSize: pH(18),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
  Container ImageTile(String path) => Container(
      decoration: BoxDecoration(color: Color.fromRGBO(190, 240, 255, 0.3), borderRadius: BorderRadius.circular(6)),
      height: pH(113),
      width: pW(113),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: petColor[400]),
          child: Image.asset(
            path,
            height: pH(75),
            width: pW(75),
          ),
        ),
      ));
}
