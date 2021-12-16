import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:petmet_app/app/dogwalker/dog_walker_tile.dart';
import 'package:petmet_app/app/dogwalker/my_dog_walker_tile.dart';
import 'package:petmet_app/app/home/models/dogWalkerPackage.dart';
import 'package:petmet_app/app/home/models/myDogWalkerPackage.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:flutter/painting.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/services/list_items_builder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class DogWalkerHomepage extends StatefulWidget {
  DogWalkerHomepage({@required this.database, @required this.uid});
  final Database database;
  final String uid;
  @override
  _DogWalkerHomepageState createState() => _DogWalkerHomepageState();
}

class _DogWalkerHomepageState extends State<DogWalkerHomepage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  String _pickedTime = '00:00';
  DogWalkerPackage _selectedPackage;
  bool _showPlan = false;
  Razorpay _razorpay;
  void _updatePackage(DogWalkerPackage package) {
    setState(() {
      _selectedPackage = package;
    });
  }

  String _timeToString(TimeOfDay chosenTime) {
    String timeString;
    TimeOfDay time=chosenTime;

    if (chosenTime == null) {
      return '00:00';
    }

    if(chosenTime.minute>0 && chosenTime.minute<=15)
    {
      time=TimeOfDay(hour: chosenTime.hour,minute: 15);
    }
    else if(chosenTime.minute>15 && chosenTime.minute<=30)
    {
      time=TimeOfDay(hour: chosenTime.hour,minute: 30);
    }
    else if(chosenTime.minute>30 && chosenTime.minute<=45)
    {
      time=TimeOfDay(hour: chosenTime.hour,minute: 45);
    }
    else if(chosenTime.minute>45 && chosenTime.minute<=59)
    {
      if(chosenTime.hour!=23)
      {
        time=TimeOfDay(hour: chosenTime.hour+1,minute: 00);
      }
      else
      {
        time=TimeOfDay(hour: 00,minute: 00);
      }
    }

    if (time.hour < 12) {
      timeString = time.minute > 9
          ? '${time.hour}:${time.minute} am'
          : '${time.hour}:0${time.minute} am';
    } else if (time.hour >= 12 && time.hour < 24) {
      timeString = time.minute > 9
          ? '${(time.hour==12?time.hour:time.hour - 12)}:${time.minute} pm'
          : '${(time.hour==12?time.hour:time.hour - 12)}:0${time.minute} pm';
    }
    return timeString;
  }

  Future<void> _pickTime() async {
    TimeOfDay time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _pickedTime = _timeToString(time);
    });
  }

  Widget _displayTime() {
    if (_pickedTime == '00:00')
      return Icon(
        Icons.access_time,
        color: Color(0xFF9F9F9F),
      );
    else
      return Text(
        _pickedTime,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF36A9CC),
        ),
      );
  }

  Future<void> _showPlanCheck() async {
    List _list = await widget.database.myDogWalkerPackagesStream().first;
    print('asdasdasdas1112312312 ${_list.isNotEmpty}');
    if (_list.isNotEmpty) {
      setState(() {
        _showPlan = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showPlanCheck();
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

    MyDogWalkerPackage _package = MyDogWalkerPackage(
      id: DateTime.now().toIso8601String(),
      cost: _selectedPackage.cost,
      durationInMonths: _selectedPackage.durationInMonths,
      description: _selectedPackage.description,
      time: _pickedTime,
      packageId: _selectedPackage.id,
      petId: globalCurrentPet.id,
      petName: globalCurrentPet.name,
      paymentVerified: true,
    );
    await widget.database.setMyDogWalkerPackage(_package);
    _showPlanCheck();
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

    final http.Response response = await http.post(
      'https://petmet.co.in/payment/servicePayment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "appId": DateTime.now().toIso8601String(),
        "_id": _selectedPackage.id,
        "type": "dogWalkerPackages",
        "uid": widget.database.getUid(),
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
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(70.0)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, size: 22, color: Color(0xFF000000)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "DOG WALKER",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFF000000),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsetsDirectional.fromSTEB(pW(18), pH(20), pW(18), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (_showPlan)
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Plan:',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, pH(25), 0, 0),
                              child: StreamBuilder<List<MyDogWalkerPackage>>(
                                stream: widget.database
                                    .myDogWalkerPackagesStream(), // define stream coming from database , make sure it's type is List<SlotModel>
                                builder: (context, snapshot) {
                                  return ListItemBuilder(
                                      neverScrollable: true,
                                      showDivider: false,
                                      snapshot: snapshot,
                                      itemBuilder: (context, dogWalkerPackage) {
                                        if (dogWalkerPackage != null)
                                          return MyDogWalkerListTile(
                                            package: dogWalkerPackage,
                                          );
                                        else
                                          return Container();
                                      });
                                },
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Color(0xff868686),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(7), pH(33), pW(7), pH(0)),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xFFF2F2F2),
                            boxShadow: [
                              new BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  blurRadius: 15.0,
                                  offset: Offset(0, 2)),
                            ],
                            borderRadius: BorderRadius.circular(2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  pW(14), pH(11), pW(13), pH(11)),
                              child: Text(
                                'Pet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF9F9F9F),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  pW(14), pH(11), pW(13), pH(11)),
                              child: Text(
                                '${globalCurrentPet.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF9F9F9F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(7), pH(24), pW(7), pH(33)),
                      child: InkWell(
                        onTap: _pickTime,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xFFF2F2F2),
                              boxShadow: [
                                new BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05),
                                    blurRadius: 15.0,
                                    offset: Offset(0, 2)),
                              ],
                              borderRadius: BorderRadius.circular(2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    pW(14), pH(11), pW(13), pH(11)),
                                child: Text(
                                  'Select Time',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF9F9F9F),
                                  ),
                                ),
                              ),
                              _displayTime(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          pW(7), pH(10), pW(7), pH(15)),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xFFF2F2F2),
                            boxShadow: [
                              new BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.05),
                                  blurRadius: 15.0,
                                  offset: Offset(0, 2)),
                            ],
                            borderRadius: BorderRadius.circular(2)),
                        child: DropdownButtonFormField(
                          //focusNode: _myFocusNode1,
                          value: dropDownValue2,
                          //onSaved: (Value) => category = Value,
                          onChanged: (String Value) {
                            setState(() {
                              dropDownValue2 = Value;
                            });
                          },

                          //dropdownColor: Color(0xFF36A9CC),
                          icon: Icon(
                            Icons.expand_more,
                            color: Color(0xFF36A9CC),
                          ),
                          items: categoryList
                              .map((categoryTitle) => DropdownMenuItem(
                                  value: categoryTitle,
                                  child: Text("$categoryTitle")))
                              .toList(),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 3,
                                ),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  pW(13), pH(10), pW(12), pH(10)),
                              counterStyle: TextStyle(
                                  fontSize: 15, color: Color(0xFF36A9CC)),
                              labelText: 'Select Time',
                              labelStyle: TextStyle(
                                  fontSize: 18, color: Color(0xFF36A9CC))),
                        ),
                      ),
                    ),*/
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(0, pH(25), 0, 0),
                      child: StreamBuilder<List<DogWalkerPackage>>(
                        stream: widget.database
                            .dogWalkerPackagesStream(), // define stream coming from database , make sure it's type is List<SlotModel>
                        builder: (context, snapshot) {
                          return ListItemBuilder(
                              neverScrollable: true,
                              showDivider: false,
                              snapshot: snapshot,
                              itemBuilder: (context, dogWalkerPackage) {
                                if (dogWalkerPackage != null)
                                  return DogWalkerListTile(
                                    package: dogWalkerPackage,
                                    updatePackage: _updatePackage,
                                    selectedPackage: _selectedPackage,
                                  );
                                else
                                  return Container();
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(pH(20)),
            child: Container(

              decoration: BoxDecoration(
                  color: Color(0xFF36A9CC),
                  borderRadius: BorderRadius.circular(pH(25))
              ),
              child: FlatButton(
                onPressed: () async {
                  if (_pickedTime == '00:00') {
                    ShowErrorDialog.show(
                      context: context,
                      title: 'No Time Selected',
                      message: 'Please Select a Time',
                    );
                  } else if (_selectedPackage == null) {
                    ShowErrorDialog.show(
                      context: context,
                      title: 'No Package Selected',
                      message: 'Please Select a Package',
                    );
                  } else {
                    Overlay.of(context).insert(_overlayEntry);
                    Map value = await sendOrder().then((value) {
                      _overlayEntry.remove();
                      return value;
                    });
                    await pay(value);
                  }
                },
                //color: Color(0xFF36A9CC),
                child: Padding(
                  padding: EdgeInsets.all(pH(0)),
                  child: Container(
                    //height: 56,
                    //width: 414,
                    decoration: BoxDecoration(
                        color: Color(0xFF36A9CC),
                        borderRadius: BorderRadius.circular(pH(25))
                    ),
                    padding: EdgeInsetsDirectional.fromSTEB(0, pH(11), 0, pH(12)),
                    child: Text(
                      "PROCEED TO PAYMENT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
