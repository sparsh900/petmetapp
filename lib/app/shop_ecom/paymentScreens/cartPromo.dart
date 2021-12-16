import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:petmet_app/app/home/models/promo.dart';

import 'successScreen.dart';


class CartWithPromo extends StatefulWidget {
  CartWithPromo({@required this.database, @required this.order, @required this.addressAndDetails});
  final Database database;
  final Map<String, dynamic> order;
  final Map<String, dynamic> addressAndDetails;
  @override
  _CartWithPromoState createState() => _CartWithPromoState();
}

class _CartWithPromoState extends State<CartWithPromo> {
  ValueNotifier<bool> useWalletMoney = ValueNotifier(false);
  ValueNotifier<bool> updateBill = ValueNotifier(false);
  ValueNotifier<bool> usePromoCode = ValueNotifier(false);

  ValueNotifier<String> error=ValueNotifier("");

  FocusNode _focusNode = FocusNode();

  TextEditingController promoCode = TextEditingController();

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }
  Map result=Map();
  Map options=Map();
  UserData userData;
  List<Promo> listOfPromos;
  OverlayEntry _overlayEntry;


  Razorpay _razorpay;
  @override
  void initState(){
    super.initState();
    getPromo();
    calculateTotal(false, false);
    createOverlay();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void createOverlay(){
    _overlayEntry=OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.75),
        child:Center(child: CircularProgressIndicator())
      ),
      opaque: false,
    );
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success...");
    print(response.toString());
    widget.database.deleteAllCartItems();
    Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SuccessScreen(database: widget.database)
      ),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed...");
    ShowErrorDialog.show(context: context,title: "Failed",message: "Transaction Failed, Payment Gateway Error");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet --  ${response.walletName}\nWe provide external wallet support :)");
  }

  Future<bool> fetchWallet() async {
    userData=await widget.database.getUserData();
    walletMoney = userData.walletMoney.toDouble();
    return true;
  }

  void evaluatePromo(){
    int isValid= listOfPromos.indexWhere((element) => (element.code == promoCode.text));
    print(listOfPromos.toString());
    print(isValid.toString());
    print(userData.usedPromo);
    print(userData.firstName);

    if( isValid != -1  && !userData.usedPromo.contains(promoCode.text)){
      usePromoCode.value=true;
      error.value="";
    }else{
      usePromoCode.value=false;

      if(isValid==-1)
          error.value="No Such Promo Available";
      else
          error.value="Already Availed Max times";
    }
    calculateTotal(useWalletMoney.value, usePromoCode.value);
    updateBill.value=!updateBill.value;
  }

  void getPromo() async {
    Stream<List<Promo>> streamOfPromos= widget.database.getPromos();
    listOfPromos=await streamOfPromos.first;
  }

  void calculateTotal(bool useWallet, bool discount) {
    double localTotal = widget.order['subTotal'];
    promoDiscount=0;
    walletDiscount=0;
    if(discount){

      Promo promoInfo = listOfPromos.firstWhere((element) => element.code == promoCode.text);

      if(localTotal > double.parse(promoInfo.discountLowerLimit)){
        double primaryDiscount= localTotal*double.parse(promoInfo.discount);
        double maxDiscount= double.parse(promoInfo.discountUpperLimit);
        promoDiscount = primaryDiscount > maxDiscount? maxDiscount : primaryDiscount;
        localTotal-= promoDiscount;
      }

    }
    if (useWallet) {
      walletDiscount = localTotal / 10 > walletMoney ? walletMoney : localTotal / 10;
      localTotal -= walletDiscount;
    }
    total=localTotal;
  }

  double walletMoney;
  double walletDiscount;
  double total;
  double promoDiscount;

  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(pH(57.0)), // here the desired height
          child: AppBar(
            title: Text("BILL  FORM"),
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: pW(19.5), vertical: pH(13.38)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureBuilder(
                  future: fetchWallet(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return InkWell(
                        onTap: () {
                          useWalletMoney.value = !useWalletMoney.value;
                          calculateTotal(useWalletMoney.value, usePromoCode.value);
                          updateBill.value = !updateBill.value;
                        },
                        child: Card(
                            elevation: 3,
                            child: Container(
                              width: pW(375),
                              padding: EdgeInsets.symmetric(vertical: pH(18.94)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: pW(16.13)),
                                      child: Text(
                                        "USE YOUR WALLET MONEY",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700], wordSpacing: 1.8),
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: useWalletMoney,
                                        builder: (context, value, child) => Checkbox(
                                          value: useWalletMoney.value,
                                          onChanged: (value) {
                                            useWalletMoney.value = !useWalletMoney.value;
                                            calculateTotal(useWalletMoney.value, usePromoCode.value);
                                            updateBill.value = !updateBill.value;
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: pW(5)),
                                        child: Text(walletMoney.truncate().toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold, wordSpacing: 1.8, fontSize: pH(24)),
                                        ),
                                      ),
                                      SvgPicture.asset('images/svg/creditBone.svg', height: pH(36), semanticsLabel: 'wallet credit token')
                                    ],
                                  )
                                ],
                              ),
                            )),
                      );
                    }else{
                      return Container(height: 0,);
                    }
                  },
                ),
                SizedBox(
                  height: pH(10),
                ),
                ValueListenableBuilder(
                  valueListenable: usePromoCode,
                  builder: (context, value, child) => Card(
                    elevation: 3,
                    child: TextFormField(
                      controller: promoCode,
                      focusNode: _focusNode,
                      onTap:() =>  usePromoCode.value=false,
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Enter Coupon Code here",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w200),
                        suffixIcon: FlatButton(
                          onPressed: () {
                            _focusNode.canRequestFocus = false;
                             evaluatePromo();
                            },
                          color: Colors.grey[100],
                          textColor: value ? Colors.green : Colors.grey[800],
                          child: Text(value ? "APPLIED" : "APPLY"),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ValueListenableBuilder(
                        valueListenable: error,
                        builder: (context, value, child) {
                          if(value!="")
                            return Text(
                              value,style: TextStyle(
                              color: Colors.red
                            ),
                          );
                          return Container(height: 0,);
                        },
                    ),

                    Container(
                      margin: EdgeInsets.only(left: pW(20)),
                      child: InkWell(
                        onTap: () async{
                          Promo codeReturned = await _promoBottomSheet(context,listOfPromos);
                          if(codeReturned!=null){
                            promoCode.text=codeReturned.code;
                            evaluatePromo();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(pH(8)),
                          child: Text("View  all  codes"),
                        ),
                      ),
                    )
                  ],
                ),
                // Align(
                //     alignment: Alignment.topRight,
                //     child:
                // ),
                SizedBox(
                  height: pH(10),
                ),
                ValueListenableBuilder(
                  valueListenable: updateBill,
                  builder: (context, value, child) => Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            'BILL  DETAILS',
                            style: TextStyle(
                              fontSize: pH(20),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Gotham',
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(
                            height: pH(20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: pH(20),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gotham',
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                "₹ " + widget.order['subTotal'].toString(),
                                style: TextStyle(
                                  fontSize: pH(20),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gotham',
                                  color: petColor,
                                ),
                              )
                            ],
                          ),
                          usePromoCode.value
                              ? SizedBox(
                                  height: pH(10),
                                )
                              : Container(
                                  height: 0,
                                ),
                          usePromoCode.value
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(
                                  fontSize: pH(20),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gotham',
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                "- ₹ " + promoDiscount.truncate().toString(),
                                style: TextStyle(
                                  fontSize: pH(20),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gotham',
                                  color: petColor,
                                ),
                              )
                            ],
                          )
                              : Container(
                            height: 0,
                          ),
                          SizedBox(
                            height: pH(10),
                          ),
                          useWalletMoney.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Wallet Discount',
                                      style: TextStyle(
                                        fontSize: pH(20),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gotham',
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Text(
                                      "- ₹ " + walletDiscount.truncate().toString(),
                                      style: TextStyle(
                                        fontSize: pH(20),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Gotham',
                                        color: petColor,
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  height: 0,
                                ),


                          Divider(
                            color: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand  Total',
                                style: TextStyle(
                                    fontSize: pH(26), fontWeight: FontWeight.w400, fontFamily: 'Gotham', color: Colors.black, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                "₹ " + total.truncate().toString(),
                                style: TextStyle(
                                    fontSize: pH(26), fontWeight: FontWeight.w600, fontFamily: 'Gotham', color: Colors.black, fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ]),
                      )),
                )
              ],
            ),
          ),
        ),
        bottomSheet: InkWell(
            onTap: ()async {
              Overlay.of(context).insert(_overlayEntry);
              Map value = await sendOrder().then((value){
                _overlayEntry.remove();
                return value;
              });
              await pay(value);
            },
            child: SizedBox(
              width: double.infinity,
              child: Container(
                height: pH(55),
                padding: EdgeInsets.all(pH(16)),
                color: petColor,
                child: Text(
                  "CONTINUE",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: pH(23), color: Colors.white),
                ),
              ),
            )));
  }


  Future<void> pay(Map value)async{
      Map result = value;
      print(result["amount_due"].toString());
      Map<String,dynamic> options = {
      "key": "rzp_test_WXBY1uT9ZE10OW",
      "currency": "INR",
      "order_id":result["id"],
      "amount": result["amount_due"].toString(),
      "name": widget.addressAndDetails["name"],
      "description": "Payment for Products",
      "prefill": {
      "contact": widget.addressAndDetails["phone"],
      "email": userData.mail
      },
      "external": {
      "wallets": ["paytm"],
      }
    };

    try {
    _razorpay.open(options);
    } catch (e) {
    print(e.toString());
    }
  }
  Future<Map> sendOrder() async {

    // Map addressObj=widget.addressAndDetails;
    // addressObj.putIfAbsent("city", () => null)
    
    final http.Response response = await http.post(
      'https://petmet.co.in/payment/order',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "products": widget.order['items'],
        "mail": userData.mail,
        "uid":  widget.database.getUid(),
        "useWallet": useWalletMoney.value,
        "promo": promoCode.text == "" || promoCode.text==null ? "no_promo" : promoCode.text,
        "deliveryAddress":widget.addressAndDetails,
      }),
    );

    if (response.statusCode == 201 || response.statusCode== 200 ) {
      return jsonDecode(response.body);
    } else {
      _overlayEntry.remove();
      ShowErrorDialog.show(context: context,title: "Failed",message: "Transaction Failed, Server Error");
      throw Exception('Failed');
    }
  }
}

Future<Promo> _promoBottomSheet(context,List<Promo> listOfPromos) async{
  return await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (BuildContext context) {
        double pH(double height) {
          return MediaQuery.of(context).size.height * (height / 896);
        }

        double pW(double width) {
          return MediaQuery.of(context).size.width * (width / 414);
        }

        return Container(
            height: pH(500),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return true;
              },

              child: SingleChildScrollView(
                child: Container(
                  height: pH(500),
                  child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: pH(10),),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: pW(20),vertical: pH(10)),
                        child: Text("Your  Promo Codes",style: TextStyle(
                          fontSize: pH(21),
                          fontWeight: FontWeight.bold,

                        ),)
                    ),
                    Flexible(
                      // height: pH(400),
                      child: NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll) {
                          overScroll.disallowGlow();
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: listOfPromos.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                trailing: FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(listOfPromos[index]);
                                    },
                                    child: Text(
                                      "Apply",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.green,
                                      ),
                                    )),
                                title: Text(listOfPromos[index].code),
                                subtitle: Text(listOfPromos[index].description),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ));
      });
}
