
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';
import 'package:petmet_app/app/home/models/pet.dart';


class ShowErrorDialog2 {
  static show({
    String title = 'title',
    String message = 'message',
    @required BuildContext context,
    @required Database database,
    final User user,
    List<Widget> actions,
  }) {
    return showPlatformDialog(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions ?? <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: (){
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                    builder: (context) => Petform(uid: user.uid, database: database,)),
              );
            },
          ),
          PlatformDialogAction(
            child: PlatformText('CANCEL'),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}