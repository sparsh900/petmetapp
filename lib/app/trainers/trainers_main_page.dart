import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/packageTrainer.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayData.dart';
import 'package:petmet_app/app/professionals_workers/variantsAndConfig/variants.dart';
import 'package:petmet_app/common_widgets/empty_content.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import './trainer_date_and_time.dart';

class TemplateTrainer extends StatefulWidget {
  TemplateTrainer(
      {@required this.database,
      this.overlayData,
      this.profession,
      this.category});
  final String profession;
  final String category;
  final OverlayData overlayData;
  final Database database;

  @override
  _TemplateTrainerState createState() => _TemplateTrainerState();
}

class _TemplateTrainerState extends State<TemplateTrainer> {
  PackageTrainer packageTrainer;
  // OverlayMaker _overlay;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _overlay = new OverlayMaker(context: context, overlayData: widget.overlayData);
    // });
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: petColor,
        title: Text(
          widget.category.toUpperCase(),
          style: TextStyle(wordSpacing: 2),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          // onPressed: () => _overlay.insert(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: pH(150),
                    color: petColor,
                    child: Center(
                      child: Text(
                        widget.profession.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: pH(20),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: pH(20), horizontal: pW(22)),
                    child: Text(
                      "About Trainers",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: pH(20),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                      future: widget.database.getTheOnlyTrainer(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildBulletPoints(
                                snapshot.data["description"]),
                          );
                        return Container(height: 0);
                      }),
                  StreamBuilder(
                      stream: widget.database
                          .getPackagesOfOnlyTrainer(whereField()),
                      builder: (context, packageSnapshot) {
                        if (packageSnapshot.hasData) {
                          return packageSnapshot.data.length != 0
                              ? ListView.builder(
                                  itemCount: packageSnapshot.data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            if (packageTrainer != null &&
                                                packageTrainer.id ==
                                                    packageSnapshot
                                                        .data[index].id)
                                              packageTrainer = null;
                                            else
                                              packageTrainer =
                                                  packageSnapshot.data[index];
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: pH(10),
                                              horizontal: pW(11)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Color((0xFFFFFFFF)),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  pW(22),
                                                                  pH(19),
                                                                  0,
                                                                  pH(16)),
                                                      child: Text(
                                                        packageSnapshot
                                                            .data[index]
                                                            .packageName
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFFF5352),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: pH(22),
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontFamily:
                                                                "Montserrat",
                                                            wordSpacing: 1.2),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    /**/
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        pH(19),
                                                                        pW(15),
                                                                        0),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Text(
                                                                " ₹${getCost(packageSnapshot.data[index])}",
                                                                //textAlign: TextAlign.right,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF36A9CC),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      pH(23),
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontFamily:
                                                                      "Montserrat",
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          _buildBulletPoints(
                                                              packageSnapshot
                                                                  .data[index]
                                                                  .description),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(0, 0,
                                                                  pW(22), 0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Container(
                                                          width: pW(25),
                                                          height: pW(25),
                                                          decoration: BoxDecoration(
                                                              color: packageTrainer !=
                                                                          null &&
                                                                      packageTrainer
                                                                              .id ==
                                                                          packageSnapshot
                                                                              .data[
                                                                                  index]
                                                                              .id
                                                                  ? Color(
                                                                      0xFFFF5352)
                                                                  : Colors
                                                                      .transparent,
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xFFFF5352),
                                                                  width: 2),
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: pH(8),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                              : Padding(
                                  padding: EdgeInsets.only(top: pH(40)),
                                  child: EmptyContent(
                                    title: "No Trainers",
                                    message: "Please change mode",
                                  ),
                                );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  SizedBox(
                    height: pH(10),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (packageTrainer == null) {
                  ShowErrorDialog.show(
                      context: context,
                      message: "Please select a package",
                      title: "Select one");
                  return;
                } else if (globalCurrentPet == null) {
                  ShowErrorDialog.show(
                      context: context,
                      title: 'No Pet Found',
                      message: 'Please add a Pet to continue');
                } else {
                  _showBottomSheet(context);
                }
              },
              child: Container(
                color: Color(0xFFFF5352),
                height: pH(10),
                child: Center(
                    child: Text(
                  "BOOK AN APPOINTMENT",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 6,
                      fontSize: pH(20)),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
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
                mode: getMode(),
                database: widget.database,
                pet: globalCurrentPet,
                package: packageTrainer,
                isHostel: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String whereField() {
    if (widget.category == Filters.atTrainingCentre.string) {
      return "isTrainingCentre";
    }
    if (widget.category == Filters.atMyHome.string) {
      return "isHomeVisit";
    }
    if (widget.category == Filters.online.string) {
      return "isOnline";
    }
    return "";
  }

  int getCost(PackageTrainer package) {
    if (widget.category == Filters.atTrainingCentre.string) {
      return package.trainingCentreCharges;
    }
    if (widget.category == Filters.atMyHome.string) {
      return package.homeVisitCharges;
    }
    if (widget.category == Filters.online.string) {
      return package.onlineCharges;
    }
    return 0;
  }

  String getMode() {
    if (widget.category == Filters.atTrainingCentre.string) {
      return "trainingCentreCharges";
    }
    if (widget.category == Filters.atMyHome.string) {
      return "homeVisitCharges";
    }
    if (widget.category == Filters.online.string) {
      return "package.onlineCharges";
    }
    return "";
  }

  List<Widget> _buildBulletPoints(String facilities) {
    List<String> bulletsInfo = facilities.split(".");
    return bulletsInfo
        .map((e) => e != ""
            ? Padding(
                padding: EdgeInsetsDirectional.fromSTEB(pW(22), 0, 0, pH(8)),
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
              )
            : Container(height: 0))
        .toList();
  }
}
