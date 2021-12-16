import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/custom_raised_button.dart';
import 'package:petmet_app/main.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String text,
    @required String assetName,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(assetName != null),
        super(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(assetName,height: 20,color: petColor,),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset(assetName,height: 20,),
                ),
              ],
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
