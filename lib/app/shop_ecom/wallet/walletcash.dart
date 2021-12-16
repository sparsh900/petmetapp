import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petmet_app/services/database.dart';

import 'package:petmet_app/common_widgets/custom_dialog_wallet.dart' as custom;
import 'package:petmet_app/common_widgets/empty_content.dart';

class WalletCash extends StatefulWidget {
  WalletCash({@required this.database});
  final Database database;
  @override
  WalletCashState createState() => WalletCashState();
}

class WalletCashState extends State<WalletCash> {

  UserData _userData;
  List<bool> condition;
  ValueNotifier<bool> oneTime=new ValueNotifier(false);

  @override
  void initState(){
    super.initState();
    getUserData();
  }
  void getUserData() async{
    print("Getting User Data -----------------");
      _userData= await widget.database.getUserData();
      condition=new List(_userData.walletHistory.length);
      condition.fillRange(0, _userData.walletHistory.length,false);
     print("Done -----------------");
     oneTime.value=true;
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context).pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {

    var format = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    return Scaffold(
      //backgroundColor: Color(0xFFE5E5E5),
      // key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: petColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "WALLET",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: 'Gotham',
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: oneTime,
        builder: (context, value, child) {
          if(value){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(12), pH(12), pW(12), pH(35)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.14),
                              offset: Offset(0, 0),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: (){
                                custom.showDialog(
                                  context: context,
                                  builder: (context) => custom.SimpleDialogWalletWala(
                                    title: Padding(padding: EdgeInsets.only(left: pW(15),top:pH(15)),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                      Text("What is Balance?",style: TextStyle(fontSize: pH(15),fontWeight: FontWeight.bold)),
                                          InkWell(
                                            onTap: () => Navigator.of(context).pop(),
                                            child: Icon(Icons.close,size: pH(15),),
                                          )
                                    ])),
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: pH(5),left: pW(15)),
                                          child: Text("Your wallet balance can be used while")),
                                      Padding(
                                          padding: EdgeInsets.only(left: pW(15)),
                                          child: Text("you place any order as instant cash.",)),
                                      Padding(
                                          padding: EdgeInsets.only(left: pW(15),top: pH(10)),
                                          child: Row(
                                            children: [
                                              Text("1",style: TextStyle(fontSize:pH(18),fontWeight: FontWeight.bold)),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: pW(5)),
                                                child: SvgPicture.asset('images/svg/creditBone.svg', height: pH(20), semanticsLabel: 'wallet credit token'),
                                              ),
                                              Text(" = ₹ 1",style: TextStyle(fontSize:pH(18),fontWeight: FontWeight.bold)),

                                            ],
                                          ),
                                      ),
                                    ],
                                  ),
                                  barrierDismissible: true,
                                  barrierColor: Colors.transparent,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, pH(7), pW(5), 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        children: [
                                          Text(
                                            "What is Balance! ",
                                            style: TextStyle(
                                              color: Color(0xFF36A9CC),
                                              fontWeight: FontWeight.w400,
                                              fontSize: pH(13),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Roboto",
                                            ),
                                          ),
                                          Icon(
                                            Icons.error_outline,
                                            size: pW(9),
                                            color: Color(0xFF36A9CC),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(pW(14), 0, 0, pH(14)),
                              child: Text(
                                "YOUR BALANCE",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: pW(11),
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(pW(15), 0, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    _userData.walletMoney.toString(),
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pW(30),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(pW(11), 0, 0, 0),
                                    child: SvgPicture.asset('images/svg/creditBone.svg', height: pW(28), semanticsLabel: 'wallet credit token'),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(12), pH(9)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "NEVER EXPIRES",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pW(10),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(12), 0, 0, pH(7)),
                      child: Text(
                        "History",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w400,
                          fontSize: pW(15),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                    _userData.walletHistory.length != 0?Flexible(child:SingleChildScrollView(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _userData.walletHistory.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  condition[index] = !condition[index];
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF8C8C8C), width: 0.5))),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(pW(11), pH(17), pW(12), pH(13)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _userData.walletHistory[index]["type"]=="sub"?"Paid on Purchases":"Cashback Received",
                                                style: TextStyle(
                                                  color: Color(0xFF000000),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: pW(18),
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: "Gotham",
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(pW(4), pH(7), 0, 0),
                                                child: Text(
"",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Color(0xFF676767),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: pW(10),
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: "Gotham",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                (_userData.walletHistory[index]["type"]=="add"?"+":"-")+_userData.walletHistory[index]["amount"].truncate().toString(),
                                                style: TextStyle(
                                                  color: _userData.walletHistory[index]["type"]=="add"?Color(0xFF03A300):Color(0xFFFF5352),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: pW(19),
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: "Gotham",
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(pW(10), 0, pW(12), 0),
                                                child: SvgPicture.asset('images/svg/creditBone.svg', height: pW(20), semanticsLabel: 'wallet credit token'),
                                              ),
                                              condition[index]?Icon(Icons.keyboard_arrow_up,color: Colors.grey,):Icon(Icons.keyboard_arrow_down,color:Colors.grey),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if ("${condition[index]}" == "true")
                                    Container(
                                      color: Color(0xFFEEEEEE),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(pW(24), pH(11), 0, pH(11)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (_userData.walletHistory[index]["type"]=="add"?"Recieved":"Paid"),
                                              // + "for ${products[index]}",
                                              style: TextStyle(
                                                color: Color(0xFF757575),
                                                fontWeight: FontWeight.w400,
                                                fontSize: pW(12),
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "Gotham",
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsetsDirectional.fromSTEB(0, pH(10), 0, 0),
                                            //   child: Text(
                                            //     "Order ID: ${orderid[index]}",
                                            //     style: TextStyle(
                                            //       color: Color(0xFF757575),
                                            //       fontWeight: FontWeight.w400,
                                            //       fontSize: pW(12),
                                            //       fontStyle: FontStyle.normal,
                                            //       fontFamily: "Gotham",
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, pH(10), 0, 0),
                                              child: Text(
                                                "Expiry: Never Expires",
                                                style: TextStyle(
                                                  color: Color(0xFF757575),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: pW(12),
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: "Gotham",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          }),
                    )): Expanded(child: EmptyContent(message: "No Orders placed yet",)),
                  ],
                );
            }else{
                 return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
            }
          }
    )
  );

  }
}
