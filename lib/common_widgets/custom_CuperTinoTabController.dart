import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/tab_item.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/others_explore/others_home.dart';

class CustomCupertinoTabController extends CupertinoTabController{
  int _tileNavigator=0;
  set tileNavigator(int tileNumber) => _tileNavigator=tileNumber;
  int get getTileNavigator => _tileNavigator;

  navigatingTheOthers() {
    if(globalNavigatorKeys[TabItem.myPet].currentState != null)
      globalNavigatorKeys[TabItem.myPet].currentState.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => OtherHomePage(),), (route) => false);
  }
}