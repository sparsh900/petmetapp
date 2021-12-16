import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/custom_raised_button.dart';
import 'package:petmet_app/main.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    @required IconData icon,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    double height=50,
    double iconSize=20,
    double textSize=15,
  })  : assert(text != null),
        assert(icon != null),
        super(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(icon,size: iconSize,color: petColor,),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Icon(icon,size: iconSize,color:petColor,),
              ),
            ],
          ),
        ),
        color: color,
        onPressed: onPressed,
        height: height,
      );
}

