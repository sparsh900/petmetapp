import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petmet_app/app/cupertino_home_scaffold.dart';
import 'package:petmet_app/app/home/home_page.dart';
import 'package:petmet_app/app/home/tab_item.dart';
import 'package:petmet_app/app/others_explore/others_home.dart';
import 'package:petmet_app/common_widgets/custom_CuperTinoTabController.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';

import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'home/models/pet.dart';

import 'package:petmet_app/app/professionals_workers/overlays/overlayMaterial.dart';
import 'package:petmet_app/app/professionals_workers/overlays/overlayData.dart';
import 'professionals_workers/variantsAndConfig/variants.dart';

import 'package:petmet_app/app/shop_ecom/shop_home/shop_home_page.dart';

//Global Variables !start!
Pet globalCurrentPet;
int globalCurrentPetValue = 0;
bool checkUserAns = false;
FirebaseMessaging fcm = FirebaseMessaging();
CustomCupertinoTabController globalNavBarController = CustomCupertinoTabController();

Map<TabItem, GlobalKey<NavigatorState>> globalNavigatorKeys = {
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.doctor: GlobalKey<NavigatorState>(),
  TabItem.shop: GlobalKey<NavigatorState>(),
  TabItem.myPet: GlobalKey<NavigatorState>(),
  //TabItem.tester: GlobalKey<NavigatorState>(),
};
//Global Variables !end!

class HomePageSkeleton extends StatefulWidget {
  HomePageSkeleton({this.user, @required this.database});
  final User user;
  final Database database;
  @override
  _HomePageSkeletonState createState() => _HomePageSkeletonState();
}

class _HomePageSkeletonState extends State<HomePageSkeleton> {
  TabItem _currentTab = TabItem.home;
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    print("tester");
    print(widget.user.uid);
    return {
      TabItem.home: (_) => HomePage(user: widget.user),
      TabItem.doctor: (_) => OverlayMaterial(
          overlayData: OverlayData(
              heading: "For what purpose are you looking for a Vet?",
              options: [Categories.consultation.string, Categories.deworming.string, Categories.vaccine.string],
              profession: Professions.vet.string)),
      TabItem.shop: (_) => ShopHomePage(),
      TabItem.myPet: (_) => Petform( uid: widget.user.uid, pet: globalCurrentPet,database: widget.database,),
      // OverlayMaterial(overlayData: OverlayData(heading: "Where do you want to groom your pet?", options: [Filters.home.string, Filters.clinic.string], profession: Professions.petGroomer.string)),
      // Container(child: Center(child: Text("Explore")),),
      //TabItem.tester: (_)=> Tester(),
    };
  }

  // final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
  //   TabItem.home: GlobalKey<NavigatorState>(),
  //   TabItem.doctor: GlobalKey<NavigatorState>(),
  //   TabItem.shop: GlobalKey<NavigatorState>(),
  //   TabItem.explore: GlobalKey<NavigatorState>(),
  //   //TabItem.tester: GlobalKey<NavigatorState>(),
  // };
  void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() async {
    bool waitAMinJustTakeYourTime = await globalNavigatorKeys[_currentTab].currentState.maybePop();
    if (!waitAMinJustTakeYourTime) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press back again to exit", backgroundColor: Colors.blueGrey[700], textColor: Colors.white);
        return Future.value(false);
      }
      if (Platform.isIOS) {
        return Future.value(true);
      } else {
        SystemNavigator.pop(animated: true);
        exit(0);
      }
    } else {
      return !waitAMinJustTakeYourTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onWillPop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
        // navigatorKeys: globalNavigatorKeys,
        // user: widget.user
      ),
    );
  }
}
