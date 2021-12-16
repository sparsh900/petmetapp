import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/models/vet.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/personal_vet_page/inner_vet_page.dart';
import 'package:petmet_app/app/personal_vet_page/show_appoinment_page.dart';
import 'package:petmet_app/app/personal_vet_page/show_vet_page.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:http/http.dart' as http;

class AppointmentListTile extends StatefulWidget {
  AppointmentListTile(
      {@required this.appointment,
      @required this.context,
      @required this.database});

  final Appointment appointment;
  final Database database;
  final BuildContext context;
  @override
  _AppointmentListTileState createState() => _AppointmentListTileState();
}

class _AppointmentListTileState extends State<AppointmentListTile> {
  Vet vet;
  bool button = true;

  Razorpay _razorpay;
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

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success...");
    print(response.toString());
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

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    String dateStringNew =
        dateString.substring(0, 10) + ' ' + dateString.substring(11);
    DateTime date = DateTime.parse(dateStringNew);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _getVet() async {
    final vetTemp = await widget.database.getVet(widget.appointment.doctorId);
    if (mounted) {
      setState(() {
        vet = vetTemp;
      });
    }
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    _getVet();
    if (vet != null) {
//      return ListTile(
//      leading: Container(
//        padding: EdgeInsets.all(10.0),
//        decoration: BoxDecoration(color: metColor, shape: BoxShape.circle),
//        child: Text(
//          showLeadText(),
//          style: TextStyle(color: Colors.white,fontSize: 20),
//        ),
//      ),
//      title: Text(
//        '${widget.appointment.time}',
//        style: TextStyle(color: Colors.black),
//      ),
//      subtitle: Text(
//        'Doctor: Dr.${vet.Name}',
//        style: TextStyle(color: Colors.grey),
//      ),
//      onTap: () => ShowAppointmentPage.show(widget.context, appointment: widget.appointment,vet: vet),
//      trailing: Icon(Icons.chevron_right),
//    );
      return GestureDetector(
        onTap: () {
          setState(() {
            button = true;
          });
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color(0xFF868686),
              width: 0.5,
            ))),
            child: Padding(
              padding:
                  EdgeInsetsDirectional.fromSTEB(pW(20), pH(35), 0, pH(12)),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0, 0, pW(12), pH(6.5)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => ShowAppointmentPage(
                                      widget.appointment, vet),
                                ),
                              );
                            },
                            child: Text(
                              "Dr.${vet.Name}",
                              style: TextStyle(
                                fontSize: pH(22),
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                        if ("${widget.appointment.status}" == "pending")
                          Text(
                            "•   PENDING",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFFB017F9),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if ("${widget.appointment.status}" == "accepted")
                          Text(
                            "•   REQUEST ACCEPTED",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFFB017F9),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if ("${widget.appointment.status}" == "complete")
                          Text(
                            "•   COMPLETE",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFF03A300),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if ("${widget.appointment.status}" == "declined")
                          Text(
                            "•   REQUEST DECLINED",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFFFF5352),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if (widget.appointment.status == null)
                          Text(
                            "•   ERROR",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFFFF5352),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if ("${widget.appointment.status}" == "cancelled")
                          Text(
                            "•   CANCELLED",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFFFF5352),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        if ("${widget.appointment.status}" == "confirmed")
                          Text(
                            "•   BOOKING CONFIRMED",
                            style: TextStyle(
                              fontSize: pH(17),
                              color: Color(0xFF03A300),
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(11)),
                      child: Text(
                        "vet",
                        style: TextStyle(
                          fontSize: pH(15),
                          color: Color(0xFF868686),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(7)),
                      child: Text(
                        "${widget.appointment.date}",
                        style: TextStyle(
                          fontSize: pH(17),
                          color: Color(0xFFB5B5B5),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, pH(18)),
                      child: Text(
                        "${widget.appointment.time}",
                        style: TextStyle(
                          fontSize: pH(17),
                          color: Color(0xFFB5B5B5),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  if (button == true &&
                      "${widget.appointment.status}" == "accepted")
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ButtonTheme(
                          minWidth: pW(198),
                          height: pH(32),
                          child: RaisedButton(
                            color: Color(0xFF03A300),
                            child: Text(
                              'Proceed to Pay ₹${vet.cost}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: pH(17)),
                            ),
                            onPressed: () async {
                              if (checkUserAns) {
                                Overlay.of(context).insert(_overlayEntry);
                                Map value = await sendOrder().then((value) {
                                  _overlayEntry.remove();
                                  return value;
                                });
                                await pay(value);
                              } else {
                                await ShowErrorDialog.show(
                                    context: context,
                                    message:
                                        'Please Update profile to continue',
                                    title: 'Profile Incomplete');
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Userform(database: widget.database),
                                ));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  if (button == true &&
                      "${widget.appointment.status}" == "declined")
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ButtonTheme(
                          minWidth: pW(198),
                          height: pH(32),
                          child: RaisedButton(
                              color: Color(0xFFB017F9),
                              child: Text(
                                'Choose another Time',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF), fontSize: pH(17)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InnerVetPage(
                                    vetData: vet,
                                    database: widget.database,
                                    pet: globalCurrentPet,
                                  ),
                                ));
                                widget.database
                                    .deleteAppointment(widget.appointment);
                              }),
                        ),
                      ),
                    ),
                  if (button == true &&
                      "${widget.appointment.status}" == "confirmed")
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ButtonTheme(
                          minWidth: pW(198),
                          height: pH(32),
                          child: RaisedButton(
                            color: Color(0xFF03A300),
                            child: Text(
                              'Locate Clinic',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: pH(17)),
                            ),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ShowVetPage(vetData: vet),
                            )),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(22), 0),
                      child: Text(
                        timeAgoSinceDate(widget.appointment.id),
                        style: TextStyle(
                          fontSize: pH(12),
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    } else {
      return Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: CircularProgressIndicator(),
      ));
    }
  }

  UserData userData;
  Future<void> pay(Map value) async {
    Map result = value;
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
    print(vet.id);

    final http.Response response = await http.post(
      'https://petmet.co.in/payment/servicePayment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "appId": widget.appointment.id,
        "_id": vet.id,
        "type": "vet",
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
}
