import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/delete--vets/petCareWidgetAssigner.dart';
import 'overlayMaker.dart';

class OverlayMaterial extends StatefulWidget {
  OverlayMaterial({this.overlayData});
  final OverlayData overlayData;
  @override
  _OverlayMaterialState createState() => _OverlayMaterialState();
}

class _OverlayMaterialState extends State<OverlayMaterial> {
  OverlayState _overlayState;
  OverlayEntry _overlayEntry;
  @override
  void initState(){
    super.initState();
    OverlayMaker overlay= new OverlayMaker(context:context,overlayData: widget.overlayData);
    WidgetsBinding.instance.addPostFrameCallback((_){
      overlay.insert();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}