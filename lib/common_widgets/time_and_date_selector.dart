import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';

class TimeAndDateSelector extends StatefulWidget {
  TimeAndDateSelector(
      {this.packageName = "",
      this.isGroomer = false,
      @required this.mode,
      @required this.database,
      @required this.doctorId,
      @required this.pet,
      this.name,
      this.address,
      this.phone,
      this.zip});
  final String mode;
  final Database database;
  final String doctorId;
  final Pet pet;
  final bool isGroomer;
  final String packageName;
  final String address, phone, zip, name;

  @override
  _TimeAndDateSelectorState createState() => _TimeAndDateSelectorState();
}

class _TimeAndDateSelectorState extends State<TimeAndDateSelector> {
  String _pickedTime = '00:00';
  String _pickedDate;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

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
      timeString = time.minute > 9 ? '${time.hour}:${time.minute} am' : '${time.hour}:0${time.minute} am';
    } else if (time.hour >= 12 && time.hour < 24) {
      timeString = time.minute > 9
          ? '${(time.hour == 12 ? time.hour : time.hour - 12)}:${time.minute} pm'
          : '${(time.hour == 12 ? time.hour : time.hour - 12)}:0${time.minute} pm';
    }
    return timeString;
  }

  Future<void> _pickTime() async {
    TimeOfDay time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _pickedTime = _timeToString(time);
    });
  }

  Future<void> _pickDate() async {
    DateTime dateTime = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
    setState(() {
      if (dateTime != null) {
        String date = dateTime.toString();
        _pickedDate = '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}';
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
              "CONFIRM BOOKING",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontFamily: "Montserrat",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> isVetBusyAt({@required String doctorId, @required String date, @required String time}) async {
    List<Appointment> appointmentsOnThatDate = await widget.database.getAppointmentsOnThatDate(whereField: 'date', date: date, doctorId: doctorId);
    if (appointmentsOnThatDate.indexWhere((appointment) => appointment.time == time && appointment.status == "accepted") != -1) return true;

    return false;
  }

  Future<void> _bookAppointment() async {
    if (_pickedTime == '00:00' || _pickedDate == null) {
      ShowErrorDialog.show(
        context: context,
        title: 'Date or Time Empty',
        message: 'Please Select Date and Time',
      );
    } else {
      if (await isVetBusyAt(doctorId: widget.doctorId, time: _pickedTime, date: _pickedDate)) {
        ShowErrorDialog.show(
          context: context,
          title: 'Time Slot Already Taken',
          message: 'Please change your date or time',
        );
        return;
      }

      try {
        final id = documentIdFromCurrentDate();
        Appointment appointment;
        if(widget.mode=="HomeVisit"){
           appointment = Appointment(
            id: id,
            time: _pickedTime,
            date: _pickedDate,
            mode: widget.mode,
            doctorId: widget.doctorId,
            petName: widget.pet.name,
            status: 'pending',
            isGroomer: widget.isGroomer,
            packageName: widget.packageName,
            userName: widget.name,
            userAddress: widget.address,
            userZip: widget.zip,
            userPhone: widget.phone
          );
        }else{
           appointment = Appointment(
            id: id,
            time: _pickedTime,
            date: _pickedDate,
            mode: widget.mode,
            doctorId: widget.doctorId,
            petName: widget.pet.name,
            status: 'pending',
            isGroomer: widget.isGroomer,
            packageName: widget.packageName,
          );
        }

        await widget.database.setAppointment(appointment);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        ShowErrorDialog.show(context: context, title: 'Appointment Request Sent', message: 'Please wait for approval');
      } on PlatformException catch (e) {
        ShowErrorDialog.show(context: context, title: 'Error', message: e.message);
      }
    }
  }
}
