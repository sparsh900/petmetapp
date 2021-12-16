import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/home/models/packageTrainer.dart';
import 'package:petmet_app/app/home/models/trainerSubscription.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class TimeAndDateSelector extends StatefulWidget {
  TimeAndDateSelector(
      {this.package,
      this.isHostel = false,
      @required this.mode,
      @required this.database,
      @required this.pet});
  final String mode;
  final Database database;
  final Pet pet;
  final bool isHostel;
  final PackageTrainer package;

  @override
  _TimeAndDateSelectorState createState() => _TimeAndDateSelectorState();
}

class _TimeAndDateSelectorState extends State<TimeAndDateSelector> {
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
    id = DateTime.now().toIso8601String();

    final http.Response response = await http.post(
      'https://petmet.co.in/payment/servicePayment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "appId": id,
        "_id": widget.package.id,
        "type": "trainerPackages",
        "mode": widget.mode,
        "uid": widget.database.getUid()
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

  double getCost() {
    if (widget.mode == "homeVisitCharges")
      return widget.package.homeVisitCharges.toDouble();
    else if (widget.mode == "onlineCharges")
      return widget.package.onlineCharges.toDouble();
    else if (widget.mode == "trainingCentreCharges")
      return widget.package.trainingCentreCharges.toDouble();
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success...");
    TrainerSubscription subscription = TrainerSubscription(
      id: id,
      mode: widget.mode,
      cost: getCost(),
      durationInMonths: widget.package.durationInMonths,
      description: widget.package.description,
      time: _pickedTime,
      packageId: widget.package.id,
      petId: globalCurrentPet.id,
      petName: globalCurrentPet.name,
      paymentVerified: true,
      //
      packageName: widget.package.packageName,
    );
    await widget.database.setTrainerSubscription(subscription);

    Navigator.of(context).pop();
    ShowErrorDialog.show(
        context: context,
        title: 'Subscribed',
        message: 'You have successfully subscribed');
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

  String _pickedTime = '00:00';
  String _pickedDate;

  String id;

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
          ? '${(time.hour == 12 ? time.hour : time.hour - 12)}:${time.minute} pm'
          : '${(time.hour == 12 ? time.hour : time.hour - 12)}:0${time.minute} pm';
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

  Future<void> _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    setState(() {
      if (dateTime != null) {
        String date = dateTime.toString();
        _pickedDate =
            '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}';
      }
    });
  }

  Widget _displayTime() {
    if (_pickedTime == '00:00')
      return Icon(
        Icons.access_time,
        size: 22,
      );
    else
      return Text(
        _pickedTime,
        style: TextStyle(
          fontSize: 22,
        ),
      );
  }

  Widget _displayDate() {
    if (_pickedDate == null)
      return Icon(
        Icons.date_range,
        size: 22,
      );
    else
      return Text(
        _pickedDate,
        style: TextStyle(
          fontSize: 22,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: _pickDate,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        _displayDate(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _pickTime,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        _displayTime(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          color: Color(0xFFFF5352),
          onPressed: _bookAppointment,
          child: Container(
            height: 56,
            width: 414,
            padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
            child: Text(
              "Proceed to Pay",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _bookAppointment() async {
    if (_pickedTime == '00:00' || _pickedDate == null) {
      ShowErrorDialog.show(
        context: context,
        title: 'Date or Time Empty',
        message: 'Please Select Date and Time',
      );
    } else {
      try {
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
              message: 'Please Update profile to continue',
              title: 'Profile Incomplete');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Userform(database: widget.database),
          ));
        }
      } on PlatformException catch (e) {
        ShowErrorDialog.show(
            context: context, title: 'Error', message: e.message);
      }
    }
  }
}
