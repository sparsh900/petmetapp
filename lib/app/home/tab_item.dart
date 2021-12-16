import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';

enum TabItem { home, doctor,shop,myPet,tester }

class TabItemData {
  const TabItemData({@required this.title,@required this.icon});
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(title: 'Home',icon: MyFlutterApp.home ),
    TabItem.doctor: TabItemData(title: 'Doctor',icon: MyFlutterApp.doctor),
    TabItem.shop: TabItemData(title: 'Shop',icon: MyFlutterApp.shop ),
    TabItem.myPet: TabItemData(title: 'My Pet',icon: MyFlutterApp.paw ),
    TabItem.tester: TabItemData(title: 'Tester',icon: Icons.laptop ),
  };
}



