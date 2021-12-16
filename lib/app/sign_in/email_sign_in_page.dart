import 'package:flutter/material.dart';
import 'package:petmet_app/app/sign_in/email_sign_form.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Color(0xFF000000)
        ),
        title: Text(
          'Sign In with Email',
          style: TextStyle(
            fontSize: 18.0,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
          child: EmailSignInForm.create(context),

        ),
      ),
      //backgroundColor: Colors.grey[200],
    );
  }
}
