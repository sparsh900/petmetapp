import 'package:flutter/material.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/services/database.dart';
import 'overlayMaker.dart';
import 'overlayData.dart';

//This page is just to have white screen below the overlay in order not to load
// the templateProfessionals page first


class OverlayMaterial extends StatefulWidget {
  OverlayMaterial({@required this.overlayData,this.database});
  final OverlayData overlayData;
  final Database database;

  @override
  _OverlayMaterialState createState() => _OverlayMaterialState();
}

class _OverlayMaterialState extends State<OverlayMaterial> {
  OverlayMaker overlay;
  @override
  void initState(){
    super.initState();

    //overlay is created using OverlayMaker class and inserted after the build method has finished execution
    //constructor called and overlay state and overlay entry created
    overlay= OverlayMaker(context:context,overlayData: widget.overlayData,database: widget.database);

    WidgetsBinding.instance.addPostFrameCallback((_){
      //overlay entry inserted in passed context
      Future.delayed(Duration(milliseconds: 200),()=>overlay.insert());
    });

  }
  void dispose(){
    overlay.dispose();
    super.dispose();
  }
  Future<bool> onWillPop() async{
    globalNavBarController.index=0;
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(child: CircularProgressIndicator()),),
      ),
    );
  }
}