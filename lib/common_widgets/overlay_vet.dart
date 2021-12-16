import 'package:flutter/material.dart';
import 'package:petmet_app/services/auth.dart';
//import 'models/pet.dart';

//Pet globalCurrentPet;

class OverlayVet extends StatefulWidget {
  OverlayVet({this.user});
  final User user;
  @override
  _OverlayVetState createState() => _OverlayVetState();
}

class _OverlayVetState extends State<OverlayVet> {
  /*TabItem _currentTab=TabItem.home;
  Map<TabItem, WidgetBuilder> get widgetBuilders{
    return {
      TabItem.home: (_)=> HomePage(user: widget.user),
      TabItem.doctor: (_) => VetsMain(pet: globalCurrentPet),
      TabItem.shop: (_)=> EcomListPage(),
      TabItem.explore: (_)=> Container(),
      TabItem.tester: (_)=> Tester(),
    };
  }
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.doctor: GlobalKey<NavigatorState>(),
    TabItem.shop: GlobalKey<NavigatorState>(),
    TabItem.explore: GlobalKey<NavigatorState>(),
    TabItem.tester: GlobalKey<NavigatorState>(),

  };
  void _select(TabItem tabItem){
    setState(()=> _currentTab=tabItem);
  }*/
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  bool checkBoxValue1 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0,
    );
    // OverlayState overlayState=Overlay.of(context);
    // OverlayEntry overlayEntry = OverlayEntry(
    //     opaque: true,
    //     builder: (context) => SafeArea(
    //       child: Center(
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: EdgeInsetsDirectional.fromSTEB(pW(70), 0, pW(70), pH(60)),
    //               child: Text(
    //                 "For what purpose are you looking for a Vet?",
    //                 style: TextStyle(
    //                   fontFamily: "Montserrat",
    //                   fontSize: pW(28),
    //                   fontWeight: FontWeight.w500,
    //                   fontStyle: FontStyle.normal,
    //                   color: Color(0xFFFFFFFF)
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsetsDirectional.fromSTEB(pW(21), 0, pW(21), 0),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.stretch,
    //                 children: [
    //                   Container(
    //                     color: Color(0xFFFFFFFF),
    //                     child: Padding(
    //                       padding: EdgeInsetsDirectional.fromSTEB(pW(32), pH(48), pW(25), pH(48)),
    //                       child: Column(
    //                         children: [
    //                           Text(
    //                             "CONSULTATION",
    //                             textAlign: TextAlign.left,
    //                             style: TextStyle(
    //                                 fontFamily: "Montserrat",
    //                                 fontSize: pW(32),
    //                                 fontWeight: FontWeight.w700,
    //                                 fontStyle: FontStyle.normal,
    //                                 color: Color(0xFF36A9CC)
    //                             ),
    //                           ),
    //                           Align(
    //                             alignment: Alignment.centerRight,
    //                             child: new Checkbox(value: checkBoxValue1,
    //                                 activeColor: Color(0xFFFF5352),
    //                                 onChanged:(bool newValue){
    //                                   setState(() {
    //                                     checkBoxValue1 = newValue;
    //                                   });
    //                                 }),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     )
    // );
    /*WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );*/
  }
}
