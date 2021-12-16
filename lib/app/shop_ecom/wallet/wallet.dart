/*import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/models/order.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/shop/cart_item.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/services/list_items_builder.dart';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Wallet extends StatefulWidget {
  CartPage({@required this.database});
  final Database database;
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  double subtotal = 0;
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  String total;
  Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    total = "0";
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<List> getItemsAsList() async {
    List allItems = [];
    Stream<List<Item>> items = await widget.database.cartStream();
    await for (List<Item> i in items) {
      for (var item in i) {
        allItems.add({
          'itemID': item.id,
          'itemName': item.details["name"],
          'itemSize': item.userSelectedSize,
          'itemCategory': item.details["category"]
        });
        print("Hello");
        print(allItems);
      }
      return allItems;
    }
  }

  String documentIdFromCurrentDate() =>
      DateTime.now().toIso8601String() + widget.database.getUid();
  Order order;
  String orderID;
  void openCheckout(String total,String orderID) async {
    UserData userData = await widget.database.getUserData();
    List items = await getItemsAsList();

    order = new Order(
      customerName: "${userData.firstName} ${userData.lastName}",
      mobileNumber: userData.mobileNumber,
      orderId: orderID,
      amount: num.parse("$total").toInt(),
      status: "draft",
      timestamp: Timestamp.now(),
      allItems: items,
      email: userData.email,
      address: userData.address,
      pincode: userData.pincode,
    );

    orderID = documentIdFromCurrentDate();
    await widget.database.setOrder(order, orderID);
    var options = {
      "key": "rzp_test_HpdJifpKFyBE1U",
      "currency": "INR",
      // "order_id":orderID,
      "amount": num.parse("$total") * 100,
      "name": "PetMet",
      "description": "Payment for cart products",
      "prefill": {
        "contact": "${userData.mobileNumber}",
        "email": "${userData.email}"
      },
      "external": {
        "wallets": ["paytm", "freecharge", "payzapp"],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    widget.database.updateOrder(order, "successful", orderID);
    widget.database.addUserPreviousOrder(order, orderID);
    widget.database.deleteAllCartItems();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed...");
    widget.database.updateOrder(order, "failed", orderID);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print(
        "External Wallet --  ${response.walletName}\nWe provide external wallet support :)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: petColor,
          title: Text(
            "CART",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 8.0),
                  Container(
                      height: 385,
                      child: Card(
                        elevation: 3,
                        child: _buildCartItems(context),
                      )),
                  SizedBox(height: 21.0),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BILL DETAILS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Gotham',
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gotham',
                                  color: Color(0xFF757575),
                                ),
                              ),
                              _subtotal(context),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'GST(12%)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gotham',
                                  color: Color(0xFF757575),
                                ),
                              ),
                              _subtotal(context, isGST: true),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cashback',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gotham',
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Row(
                                children: [
                                  _subtotal(context, isCashback: true),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.monetization_on,
                                    color: Color(0xFFFFC700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.black),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Gotham',
                                  color: Color(0xFF000000),
                                ),
                              ),
                              _subtotal(context, isTotal: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 45.0),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              color: Color(0xFFFF5352),

              onPressed: () async {
                if (checkUserAns) {
                  var authn = 'Basic ' +
                      base64Encode(utf8.encode(
                          'rzp_test_HpdJifpKFyBE1U:0PFGwg69u1f9cNnAYSBCkh8r'));

                  var headers = {
                    'content-type': 'application/json',
                    'Authorization': authn,
                  };
                  var data =
                      '{ "amount": ${total*100}, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }';
                  var res = await http.post(
                      'https://api.razorpay.com/v1/orders',
                      headers: headers,
                      body: data);
                  if (res.statusCode != 200)
                    throw Exception(
                        'http.post error: statusCode= ${res.statusCode}');
                  print('ORDER ID response => ${res.body}');

                  print(json.decode(res.body)['id'].toString());

                  openCheckout(total,json.decode(res.body)['id'].toString());
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Userform(database: widget.database),
                      ));
                }
              },
              // ShowErrorDialog.show(
              // context: context,
              // title: 'Coming Soon',
              // message: 'Payment method coming soon'),
              child: Container(
                height: 56,
                width: 414,
                padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                child: Text(
                  "PROCEED TO CHECKOUT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context) {
    return StreamBuilder(
      stream: widget.database.cartStream(),
      builder: (context, snapshot) {
        return ListItemBuilder(
            snapshot: snapshot,
            showDivider: true,
            itemBuilder: (context, item) {
              return CartItem(item: item, database: widget.database);
            });
      },
    );
  }

  Widget _subtotal(BuildContext context,
      {bool isTotal = false, bool isGST = false, bool isCashback = false}) {
    return StreamBuilder<List<Item>>(
      stream: widget.database.cartStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double cost = 0;
          List<Item> items = snapshot.data;
          for (int i = 0; i < items.length; i++) {
            cost = cost +
                double.tryParse(items[i].details['cost']) *
                    items[i].userSelectedQuantity;
          }
          if (isTotal) {
            total = "${(cost + cost * 0.12).toStringAsFixed(2)}";
            return Text(
              '\u20b9${(cost + cost * 0.12).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotham',
                fontSize: 24.0,
                color: Color(0xFF000000),
              ),
            );
          } else if (isGST) {
            return Text(
              '\u20b9${(cost * 0.12).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotham',
                color: petColor,
                fontSize: 17.0,
              ),
            );
          } else if (isCashback) {
            return Text(
              '${((cost + cost * 0.12) * 0.10).toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotham',
                color: petColor,
                fontSize: 17.0,
              ),
            );
          } else {
            return Text(
              '\u20b9${cost.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Gotham',
                color: petColor,
                fontSize: 17.0,
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
*/