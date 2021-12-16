import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:petmet_app/common_widgets/hexColor.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

import 'home/models/cartNumberNotifier.dart';
import 'home_page_skeleton.dart';

class CupertinoHomeScaffold extends StatefulWidget {
  CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.widgetBuilders,
    // @required this.navigatorKeys,
    // this.user
  }) : super(key: key);
  // final User user;
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  // final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  _CupertinoHomeScaffoldState createState() => _CupertinoHomeScaffoldState();
}

class _CupertinoHomeScaffoldState extends State<CupertinoHomeScaffold> {
  // final CupertinoTabController _controller=CupertinoTabController();
  Database database;
  int cartNumber = 0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(new Duration(seconds: 5), (_) {
    //   setState(() {
    //     cartNumber=
    //   });
    // });
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   database = Provider.of<Database>(context, listen: false);
    //   CollectionReference reference = Firestore.instance.collection(APIPath.userCart(database.getUid()));
    //   reference.snapshots().listen((querySnapshot) {
    //     int localCartNumber = 0;
    //     querySnapshot.documents.forEach((element) {
    //       localCartNumber += Item.fromMap(element.data, element.documentID).userSelectedQuantity;
    //     });
    //     setState(() {
    //       cartNumber = localCartNumber;
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartNumber>(
      // value: (_, __) => CartNumber(cartNumber: cartNumber),
      create: (context) => CartNumber(context),
      child: CupertinoTabScaffold(
        controller: globalNavBarController,
        tabBar: CupertinoTabBar(
          activeColor: HexColor("#36A9CC"),
          inactiveColor: Colors.grey,
          items: [
            _buildItem(TabItem.home),
            _buildItem(TabItem.doctor),
            _buildItem(TabItem.shop),
            _buildItem(TabItem.myPet),
            //_buildItem(TabItem.tester),
          ],
          onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(navigatorKey: globalNavigatorKeys[item], builder: (context) => widget.widgetBuilders[item](context));
        },
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData.icon,
        size: 21,
      ),
      label: itemData.title,
    );
  }
}
