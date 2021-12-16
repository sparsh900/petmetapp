import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/hostel.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/hostel/hostel_payment.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class InnerHostelPage extends StatefulWidget {
 InnerHostelPage({@required this.hostelData, @required this.database,@required this.pet});
 final Hostel hostelData;
 final Database database;
 final Pet pet;
  @override
  InnerHostelPageState createState() => InnerHostelPageState();
}

class InnerHostelPageState extends State<InnerHostelPage> {

  TimeOfDay pickUpTime,returnTime;
  DateTime pickUpDate,returnDate;


  String _timeToString(TimeOfDay time) {
    String timeString;

    if (time == null) {
      return '00:00';
    }



    if (time == null) {
      return '00:00';
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

  Future<TimeOfDay> _pickTime() async {
    TimeOfDay time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if(time.minute>=1 && time.minute<15){
      time = TimeOfDay(hour: time.hour, minute: 15);
    }else if(time.minute>=16 && time.minute<30){
      time = TimeOfDay(hour: time.hour, minute: 30);
    }else if(time.minute>=31 && time.minute<45){
      time = TimeOfDay(hour: time.hour, minute: 45);
    }else if(time.minute>=46 && time.minute<=59 && time.hour!=23){
      time = TimeOfDay(hour: time.hour+1, minute:0);
    }else if(time.minute>=46 && time.minute<=59){
      time = TimeOfDay(hour: 0, minute:0);
    }




    return time;
  }

  Future<DateTime> _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (dateTime != null) {
      return dateTime;
    }
    return null;
  }


  Widget _displayTime(TimeOfDay timeOfDay) {
    String time = _timeToString(timeOfDay);


    String display;
    if (time == '00:00')
      display='Select Time';
    else
      display=time;


    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          pW(8), pH(0), pW(6), pH(0)),
      child: Text(
        display,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF36A9CC),
        ),
      ),
    );
  }
  String _dateToString(DateTime dateTime){
    String date = dateTime.toString();
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}';
  }
  Widget _displayDate(DateTime dateTime) {
    String dateString;
    if (dateTime != null) {
      dateString = _dateToString(dateTime);
    }

    String display;
    if (dateString == null)
      display ='Select Date';
    else
      display= dateString;


    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          pW(8), pH(0), pW(6), pH(0)),
      child: Text(
        display,
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF36A9CC),
        ),
      ),
    );
  }

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }


  bool flag=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(pH(48.0)), // here the desired height
        child: AppBar(
          backgroundColor: petColor,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back,
                size: 22, color: Color(0xFFFFFFFF)),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 15,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: pH(285),
                    child: Image.network(
                      widget.hostelData.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        pW(19), pH(18), 0, pH(19)),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              width: 0.6,
                              color: Color(0xFF868686),
                            ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, pH(10)),
                            child: Text(
                              "Name: ",
                              style: TextStyle(
                                color: Color(0xFF36A9CC),
                                fontWeight: FontWeight.normal,
                                fontSize: pH(14),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                pW(1), 0, pW(12), 0),
                            child: Text(
                              widget.hostelData.hostelName,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.normal,
                                fontSize: pH(18),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        pW(19), pH(11), 0, pH(19)),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              width: 0.6,
                              color: Color(0xFF868686),
                            ))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, pH(10)),
                            child: Text(
                              "Address:",
                              style: TextStyle(
                                color: Color(0xFF36A9CC),
                                fontWeight: FontWeight.normal,
                                fontSize: pH(14),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                pW(1), 0, pW(12), 0),
                            child: Text(
                              widget.hostelData.Address+", "+widget.hostelData.city,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.normal,
                                fontSize: pH(18),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        pW(19), pH(11), 0, pH(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, pH(10)),
                            child: Text(
                              "Description:",
                              style: TextStyle(
                                color: Color(0xFF36A9CC),
                                fontWeight: FontWeight.normal,
                                fontSize: pH(14),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                pW(1), 0, pW(12), 0),
                            child: InkWell(
                              child: Text(
                                widget.hostelData.description,
                                maxLines: flag ? 1 : 18,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.normal,
                                  fontSize: pH(18),
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "Roboto",
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  flag = !flag;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(pW(21),pH(25), pW(18), pH(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFFFFFFF),
                        boxShadow: [
                          new BoxShadow(
                              color: Color.fromRGBO(124, 124, 124, 0.14),
                              blurRadius: 7,
                              offset: Offset(
                                  0,
                                  0
                              )
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(16), 0, pH(28)),
                            child: Column(
                              children: [
                                Text(
                                  "Per Hour",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFF5352),
                                    fontWeight: FontWeight.w400,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Text(
                                    "₹${widget.hostelData.costPerHour}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pH(21),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(23), 0, pH(22)),
                            child: Container(
                              color: Color(0xFF36A9CC),
                              height: pH(50),
                              width: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(16), 0, pH(28)),
                            child: Column(
                              children: [
                                Text(
                                  "Per Day",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFF5352),
                                    fontWeight: FontWeight.w400,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Text(
                                    "₹${widget.hostelData.costPerDay}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF36A9CC),
                                      fontWeight: FontWeight.w600,
                                      fontSize: pH(21),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(pW(2),pH(25), pW(18), pH(16)),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Color(0xFFAAAAAA),
                              width: 1
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(pW(15), pH(16), pH(10), pH(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Pickup On",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                    fontWeight: FontWeight.w400,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Container(
                                    width: pW(155),
                                    height: pH(30),
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
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime date = await _pickDate();
                                        setState(() {
                                          pickUpDate = date;
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _displayDate(pickUpDate),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Container(
                                    width: pW(155),
                                    height: pH(30),
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
                                    child: InkWell(
                                      onTap: () async {
                                        TimeOfDay time = await _pickTime();
                                        setState(() {
                                          pickUpTime = time;
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _displayTime(pickUpTime),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, pH(23), 0, pH(22)),
                            child: Container(
                              color: Color(0xFF36A9CC),
                              height: pH(120),
                              width: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(pW(10), pH(16), pH(15), pH(24)),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Return By",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9A9A9A),
                                    fontWeight: FontWeight.w400,
                                    fontSize: pH(14),
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Container(
                                    width: pW(155),
                                    height: pH(30),
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
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime date = await _pickDate();
                                        setState(() {
                                          returnDate = date;
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _displayDate(returnDate),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(15), 0, 0),
                                  child: Container(
                                    width: pW(155),
                                    height: pH(30),
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
                                    child: InkWell(
                                      onTap: () async {
                                        TimeOfDay time = await _pickTime();
                                        setState(() {
                                          returnTime = time;
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _displayTime(returnTime),
                                          ],
                                        ),
                                      ),
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
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                if(pickUpTime != null  && pickUpDate != null && returnTime != null && returnDate != null){
                  Map receipt = receiptObjectCreator();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelPayment(hostelData: widget.hostelData,database: widget.database, receipt: receipt,),
                    )
                  );
                }else{
                  ShowErrorDialog.show(context: context,message: "Please select Time/Date",title: "Select Time/Date");
                }
              },
              child: Container(
                color: petColor,
                child: Center(
                  child: Text("Continue",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: pH(24)
                  ),),
                ),
              ),
            ),
          ),
          //BookAppointmentButton(database: widget.database,doctorId: widget.vetData.id,pet: widget.pet,contextPrevious: context,),
        ],
      ),
    );
  }



  Map receiptObjectCreator(){
    
    DateTime pickUp = DateTime(pickUpDate.year,pickUpDate.month,pickUpDate.day,pickUpTime.hour,pickUpTime.minute);
    DateTime returnBy = DateTime(returnDate.year,returnDate.month,returnDate.day,returnTime.hour,returnTime.minute);


    Duration diff = returnBy.difference(pickUp);

    int noOfDays=diff.inDays;
    double noOfHours=0.0;

    if(diff.inHours % 24 >= widget.hostelData.dayDuration){
      noOfDays++;
    }else{
      noOfHours= (diff.inHours % 24)/1.0;
      if(diff.inMinutes % 60 != 0 ){
        print(diff.inMinutes);
        noOfHours += (diff.inMinutes % 60)/60.00;
      }
    }
    print(noOfHours);
    print(noOfDays);
    return {
      'noOfDays': noOfDays,
      'noOfHours': noOfHours,
      'pickUpDate': _dateToString(pickUpDate),
      'pickUpTime': _timeToString(pickUpTime),
      'returnDate': _dateToString(returnDate),
      'returnTime': _timeToString(returnTime),
    };
  }
}


