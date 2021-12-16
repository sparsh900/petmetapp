import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/common_widgets/input_location.dart';
import 'package:petmet_app/app/home/models/location.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/services/database.dart';

class LocationsPage extends StatelessWidget {
  LocationsPage({@required this.database});

  final Database database;

  Future<void> _createLocation(BuildContext context) async {
    try {
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => InputLocation(),
      ));
    } on PlatformException catch (e) {
      print(e.toString());
      ShowErrorDialog.show(
        title: 'Operation Failed',
        message: e.details,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createLocation(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<List<Location>>(
      stream: database.locationsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.position['geopoint'].latitude.toString())).toList();
          return ListView(children: children);
        } else if (snapshot.hasError) {
          return Center(child: Text('some error occured'));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
