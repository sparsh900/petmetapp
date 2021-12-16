import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/item.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/manageAddresses/manageAddresses.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/services/list_items_builder.dart';

import 'cart_item.dart';

class CartPage extends StatefulWidget {
  CartPage({this.database});
  final Database database;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double subtotal = 0;
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  // bool isNoItemOutOfStock=true;

  double total;
  // Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    total = 0.0;
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  Future<void> _checkUserData(Database database) async {
    bool ans = await database.checkUserData();

    if (!mounted) return;

    if (ans) {
      setState(() {
        checkUserAns = true;
      });
    } else {
      setState(() {
        checkUserAns = false;
      });
    }
  }

  Future<bool> checkIfAnyItemIsOutOfStock() async {}

  Future<List> getItemsAsList() async {
    List allItems = [];
    Stream<List<Item>> items = widget.database.cartStream();
    await for (List<Item> i in items) {
      for (var item in i) {
        print(item.details['category']);
        String itemId = item.id.split('Size=')[0];

        DocumentSnapshot individualItem = await widget.database.getItemsData(item.details['category'], itemId);
        print(individualItem.data.toString());
        if (int.parse(individualItem.data["details"]["quantity"]) != 0) {
          allItems.add({
            'productId': itemId,
            'units': item.userSelectedQuantity,
            // 'itemSize': item.userSelectedSize,
            'category': item.details["category"],
            "itemName": item.details["name"],
            "cost": individualItem.data["details"]["cost"],
            "userSelectedSize": item.userSelectedSize,
            "productImageLink": item.details["url"],
          });
        } else {
          await showDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              content: Text("${item.details["name"]} is out of stock"),
              actions: [
                RaisedButton(
                  child: Text("Keep"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                RaisedButton(
                    color: Colors.redAccent,
                    child: Text("Delete"),
                    onPressed: () {
                      widget.database.deleteCartItem(item);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
          return null;
        }
      }
      return allItems;
    }
  }

  // String documentIdFromCurrentDate() =>
  //     DateTime.now().toIso8601String() + widget.database.getUid();
  // Order order;
  // String orderID;
  // void openCheckout(String total,String orderID) async {
  //   UserData userData = await widget.database.getUserData();
  //   List items = await getItemsAsList();
  //
  //   order = new Order(
  //     customerName: "${userData.firstName} ${userData.lastName}",
  //     mobileNumber: userData.mobileNumber,
  //     orderId: orderID,
  //     amount: num.parse("$total").toInt(),
  //     status: "draft",
  //     timestamp: Timestamp.now(),
  //     allItems: items,
  //     email: userData.email,
  //     address: userData.address,
  //     pincode: userData.pincode,
  //   );
  //
  //   orderID = documentIdFromCurrentDate();
  //   await widget.database.setOrder(order, orderID);
  //   var options = {
  //     "key": "rzp_test_HpdJifpKFyBE1U",
  //     "currency": "INR",
  //     // "order_id":orderID,
  //     "amount": num.parse("$total") * 100,
  //     "name": "PetMet",
  //     "description": "Payment for cart products",
  //     "prefill": {
  //       "contact": "${userData.mobileNumber}",
  //       "email": "${userData.email}"
  //     },
  //     "external": {
  //       "wallets": ["paytm", "freecharge", "payzapp"],
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  //
  // void handlePaymentSuccess(PaymentSuccessResponse response) {
  //   widget.database.updateOrder(order, "successful", orderID);
  //   widget.database.addUserPreviousOrder(order, orderID);
  //   widget.database.deleteAllCartItems();
  // }
  //
  // void handlePaymentError(PaymentFailureResponse response) {
  //   print("Payment failed...");
  //   widget.database.updateOrder(order, "failed", orderID);
  // }
  //
  // void handleExternalWallet(ExternalWalletResponse response) {
  //   print(
  //       "External Wallet --  ${response.walletName}\nWe provide external wallet support :)");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "CART",
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Column(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: pH(485), //385 given
                    child: Card(
                      elevation: 3,
                      child: _buildCartItems(context),
                    )),
                Card(
                    elevation: 3,
                    color: Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    shadowColor: Color.fromRGBO(0, 0, 0, 0.8),
                    child: Padding(

                      padding: const EdgeInsets.all(0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(16), 0, pH(12)),
                              child: Text(
                                'BILL  DETAILS',
                                style: TextStyle(
                                  fontSize: pW(16),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF000000),


                                ),
                              ),
                            ),
                            Divider(
                              color: Color(0xFF757575),
                              thickness: 0.5,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(10), pH(22), pH(18)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontSize: pW(20),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Gotham',
                                      color: Colors.black,
                                    ),
                                  ),
                                  _subtotal(context),
                                ],
                              ),
                            ),
                          ]),

                    ))
              ],
            ),
          ),
          SizedBox(
            height: pH(100),
          )
        ]),
      ),
      bottomSheet: InkWell(
          onTap: () async {
            List items = await getItemsAsList();

            if (items == null) {
              return;
            }

            if (items.length == 0) {
              await ShowErrorDialog.show(context: context, message: 'Please add an item to continue', title: 'Cart Empty');
              return;
            }

            setState(() {
              _checkUserData(widget.database);
            });

            if (checkUserAns) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ManageAddress(database: widget.database, isManageAddress: false, order: {'items': items, 'subTotal': total}),
              ));
            } else {
              await ShowErrorDialog.show(context: context, message: 'Please Update profile to continue', title: 'Profile Incomplete');
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Userform(database: widget.database),
              ));
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(20), pH(28), pW(20), pH(18)),
              child: Container(
                height: pH(55),
                padding: EdgeInsets.all(pH(14)),
                decoration: BoxDecoration(color: Color(0xFF36A9CC), borderRadius: BorderRadius.circular(25)),
                child: Text(
                  "Proceed",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: pH(23), color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )),
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

  Widget _subtotal(BuildContext context, {bool isTotal = false, bool isGST = false, bool isCashback = false}) {
    return StreamBuilder<List<Item>>(
      stream: widget.database.cartStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double cost = 0;
          List<Item> items = snapshot.data;
          for (int i = 0; i < items.length; i++) {
            cost = cost + double.tryParse(items[i].details['cost']) * items[i].userSelectedQuantity;
          }
          if (isTotal) {
            // total = "${(cost + cost * 0.12).toStringAsFixed(2)}";
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
            total = cost;
            return Text(
              '\u20b9${cost.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Gotham',
                color: Color(0xFF000000),
                fontSize: pW(24),
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
