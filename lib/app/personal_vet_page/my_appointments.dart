import 'package:flutter/material.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/appointment.dart';
import 'package:petmet_app/app/personal_vet_page/appointment_list_tile.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';
import 'package:petmet_app/services/list_items_builder.dart';

import '../grommers/groomerAppointmentListTile.dart';

class MyAppointmentsPage extends StatefulWidget {
  MyAppointmentsPage({@required this.database});
  final Database database;

  @override
  _MyAppointmentsPageState createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

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
            "MY APPOINTMENTS",
            style: TextStyle(
              fontSize: pH(24),
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Appointment>>(
      stream: widget.database
          .appointmentsStream(), // define stream coming from database , make sure it's type is List<SlotModel>
      builder: (context, snapshot) {
        return ListItemBuilder(
            snapshot: snapshot,
            itemBuilder: (context, appointment) {
              if (appointment.petName == globalCurrentPet.name ) {
                if(!appointment.isGroomer)
                return AppointmentListTile(
                  appointment: appointment,
                  database: widget.database,
                  context: context,
                );
                else if( appointment.isGroomer)
                  return GroomerAppointmentListTile(
                  appointment: appointment,
                  database: widget.database,
                  context: context,
                );
                else return Container();

              }
              else return Container();
            });
      },
    );
  }
}
