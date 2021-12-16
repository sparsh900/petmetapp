import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/hostel.dart';
import 'package:petmet_app/app/home/models/hostelBooking.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';

import '../../main.dart';
import '../home_page_skeleton.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class HostelPayment extends StatefulWidget {
  HostelPayment(
      {@required this.hostelData,
      @required this.database,
      @required this.receipt});
  final Database database;
  final Map receipt;
  final Hostel hostelData;
  @override
  _HostelPaymentState createState() => _HostelPaymentState();
}

class _HostelPaymentState extends State<HostelPayment> {
  Razorpay _razorpay;
  String _appId;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  void initState() {
    super.initState();
    createOverlay();
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

  OverlayEntry _overlayEntry;

  void createOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
          color: Colors.black.withOpacity(0.75),
          child: Center(child: CircularProgressIndicator())),
      opaque: false,
    );
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success...");
    print(response.toString());

    HostelBooking hostelBooking = HostelBooking(
      hostelName: widget.hostelData.hostelName,
      hostelId: widget.hostelData.id,
      cost: (widget.hostelData.costPerHour * widget.receipt["noOfHours"] +
          widget.hostelData.costPerDay * widget.receipt["noOfDays"]),
      noOfDays: widget.receipt['noOfDays'],
      noOfHours: widget.receipt['noOfHours'],
      pickupDate: widget.receipt["pickUpDate"],
      pickupTime: widget.receipt["pickUpTime"],
      returnDate: widget.receipt["returnDate"],
      returnTime: widget.receipt["returnTime"],
      id: _appId,
    );
    await widget.database.bookHostel(hostelBooking);
    await ShowErrorDialog.show(
      context: context,
      title: "Booking Complete",
      message: "Hostel Booked",
    );
    Navigator.of(context).pop();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed...");
    ShowErrorDialog.show(
        context: context,
        title: "Failed",
        message: "Transaction Failed, Payment Gateway Error");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print(
        "External Wallet --  ${response.walletName}\nWe provide external wallet support :)");
  }

  UserData userData;

  Future<void> pay(Map value) async {
    Map result = value;
    // await sendOrder();
    print(result["amount_due"].toString());
    Map<String, dynamic> options = {
      "key": "rzp_test_WXBY1uT9ZE10OW",
      "currency": "INR",
      "order_id": result["id"],
      "amount": result["amount_due"].toString(),
      "name": userData.firstName + " " + userData.lastName,
      "description": "Payment for Products",
      "prefill": {"contact": userData.phone, "email": userData.mail},
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
    userData = await widget.database.getUserData();
    _appId=DateTime.now().toIso8601String();

    final http.Response response = await http.post(
      'https://petmet.co.in/payment/servicePayment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "appId": _appId,
        "_id": widget.hostelData.id,
        "type": "hostels",
        "uid": widget.database.getUid(),
        "noOfDays":widget.receipt['noOfDays'],
        "noOfHours":widget.receipt['noOfHours'],
        "pickupDate": widget.receipt["pickUpDate"],
        "pickupTime": widget.receipt["pickUpTime"],
        "returnDate": widget.receipt["returnDate"],
        "returnTime": widget.receipt["returnTime"],
        "hostelName": widget.hostelData.hostelName,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _overlayEntry.remove();
      ShowErrorDialog.show(
          context: context,
          title: "Failed",
          message: "Transaction Failed, Server Error");
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFF36A9CC),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFFFFFFFF)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.hostelData.hostelName,
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
      body: Column(
        children: [
          Expanded(
              flex: 14,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    pW(16), pH(28), pW(16), pH(50)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      new BoxShadow(
                          color: Color.fromRGBO(124, 124, 124, 0.14),
                          blurRadius: 7,
                          offset: Offset(0, 0)),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        pW(15), pH(18), pW(20), pH(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, pW(15), 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, pH(20)),
                                    child: Text(
                                      "Pickup On:",
                                      style: TextStyle(
                                        color: Color(0xFF9A9A9A),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, pH(15)),
                                    child: Text(
                                      "Return By:",
                                      style: TextStyle(
                                        color: Color(0xFF9A9A9A),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(16),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, pH(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(8), 0),
                                          child: Text(
                                            widget.receipt["pickUpDate"],
                                            style: TextStyle(
                                              color: Color(0xFF36A9CC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: pH(18),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(9), 0),
                                          child: Text(
                                            "at",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: pH(12),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(8), 0),
                                          child: Text(
                                            widget.receipt["pickUpTime"],
                                            style: TextStyle(
                                              color: Color(0xFF36A9CC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: pH(18),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, pH(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(8), 0),
                                          child: Text(
                                            widget.receipt["returnDate"],
                                            style: TextStyle(
                                              color: Color(0xFF36A9CC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: pH(18),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(9), 0),
                                          child: Text(
                                            "at",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontWeight: FontWeight.w500,
                                              fontSize: pH(12),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, pW(8), 0),
                                          child: Text(
                                            widget.receipt["returnTime"],
                                            style: TextStyle(
                                              color: Color(0xFF36A9CC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: pH(18),
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "Montserrat",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(50), 0, pW(60), 0),
                          child: Divider(
                            color: Color(0xFFBCBCBC),
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0, pH(20), 0, pH(0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, pW(5), 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, pH(20)),
                                      child: Text(
                                        "No. of Days:",
                                        style: TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontWeight: FontWeight.w400,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, pH(15)),
                                      child: Text(
                                        "No. of Hours:",
                                        style: TextStyle(
                                          color: Color(0xFF2C2C2C),
                                          fontWeight: FontWeight.w400,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, pH(20)),
                                    child: Text(
                                      "${widget.receipt["noOfDays"]} Days",
                                      style: TextStyle(
                                        color: Color(0xFF36A9CC),
                                        fontWeight: FontWeight.w600,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${widget.receipt["noOfHours"].toStringAsFixed(2)}  hours",
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pH(18),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    pW(12), 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, pH(20)),
                                      child: Text(
                                        "x${widget.hostelData.costPerDay.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontWeight: FontWeight.w400,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "x${widget.hostelData.costPerHour.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        color: Color(0xFFAFAFAF),
                                        fontWeight: FontWeight.w400,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    pW(12), 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, pH(20)),
                                      child: Text(
                                        "₹${(widget.hostelData.costPerDay * widget.receipt["noOfDays"]).toStringAsFixed(0)}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                          fontWeight: FontWeight.w500,
                                          fontSize: pH(18),
                                          fontStyle: FontStyle.normal,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹${(widget.hostelData.costPerHour * widget.receipt["noOfHours"]).toStringAsFixed(0)}",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontWeight: FontWeight.w500,
                                        fontSize: pH(18),
                                        fontStyle: FontStyle.normal,
                                        fontFamily: "Montserrat",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(200), 0, 0, pH(0)),
                          child: Divider(
                            color: Color(0xFFBCBCBC),
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                pW(0), 0, pW(4), pH(0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: pW(10)),
                                  child: Text(
                                    "TOTAL:",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF36A89CC),
                                      fontWeight: FontWeight.w500,
                                      fontSize: pH(18),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹${(widget.hostelData.costPerHour * widget.receipt["noOfHours"] + widget.hostelData.costPerDay * widget.receipt["noOfDays"]).toStringAsFixed(0)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF36A9CC),
                                    fontWeight: FontWeight.w500,
                                    fontSize: pH(18),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              pW(200), 0, 0, pH(8)),
                          child: Divider(
                            color: Color(0xFFBCBCBC),
                            thickness: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                if (checkUserAns) {
                  //TODO payment

                  //Send
                  // widget.receipt["noOfHours"]   //double ,
                  // widget.receipt["noOfDays"]   //int
                  // widget.hostelData.id
                  // app_id (generate here using current time and reuse it when storing in Database)
                  // type: "hostels"
                  Overlay.of(context).insert(_overlayEntry);
                  Map value = await sendOrder().then((value) {
                    _overlayEntry.remove();
                    return value;
                  });
                  await pay(value);
                } else {
                  await ShowErrorDialog.show(
                      context: context,
                      message: 'Please Update profile to continue',
                      title: 'Profile Incomplete');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Userform(database: widget.database)));
                }
              },
              child: Container(
                color: Color(0xFF36A9CC),
                child: Center(
                  child: Text(
                    "Proceed to Pay",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: pH(24),
                        wordSpacing: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
