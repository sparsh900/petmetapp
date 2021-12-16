import 'package:flutter/material.dart';
import 'package:petmet_app/common_widgets/custom_raised_button.dart';
import 'package:petmet_app/main.dart';

class FormSubmitButton extends CustomRaisedButton{

  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
}): super(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
        height:46.0,
        onPressed: onPressed,
        color: petColor,
        borderRadius: 4.0,
      );
}