import 'package:flutter/material.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/home/models/vet.dart';
import 'package:petmet_app/app/personal_vet_page/show_vet_page.dart';
import 'package:petmet_app/main.dart';

class ShowAppointmentPage extends StatelessWidget {
  ShowAppointmentPage(this.appointment, this.vet);

  final Appointment appointment;
  final Vet vet;

  static void show(BuildContext context,
      {@required Appointment appointment, @required Vet vet}) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: false,
      builder: (context) => ShowAppointmentPage(appointment, vet),
    ));
  }

  double pH(double height, BuildContext context) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width, BuildContext context) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(pH(54.0, context)), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xFFF1F1F1),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFF343434),
          ),
          centerTitle: true,
          title: Image.asset(
            'images/petmet-logo.png',
            width: pW(130, context),
            height: pH(33, context),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 12, 0),
              child: InkWell(
                onTap: () {},
                child: Icon(Icons.filter_list),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        appointment.time,
                        style: TextStyle(
                          color: petColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5))),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        appointment.date,
                        style: TextStyle(
                          color: petColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5))),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mode',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        appointment.mode,
                        style: TextStyle(
                          color: petColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5))),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pet',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${appointment.petName}',
                        style: TextStyle(
                          color: petColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5))),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Doctor Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${vet.Name}',
                        style: TextStyle(
                          color: petColor,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 0.5))),
                ),
              ],
            ),
          ),
          RaisedButton(
            color: petColor,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowVetPage(vetData: vet),
            )),
            child: Container(
              height: 56,
              width: 414,
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
              child: Text(
                "SHOW VET DETAILS",
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
        ],
      ),
    );
  }
}
