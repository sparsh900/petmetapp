import 'package:flutter/material.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/sign_in/sign_in_page.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          Database database;
          if (user == null) {
            return SignInPage();
          } else {
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid,email: user.email),
              child:HomePageSkeleton(user: user, database: database)
            ); // placeholder
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
