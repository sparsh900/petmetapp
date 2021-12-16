import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petmet_app/common_widgets/hexColor.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;

class ReferScreen extends StatelessWidget {
  final String link =Platform.isIOS?"---Coming Soon---":"https://play.google.com/store/apps/details?id=com.petmet.petmet_app";

  final String subject="PetMet Referral Link";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Refer a friend",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/svg/referAFriend.svg', semanticsLabel: 'Refer a friend'),
              SizedBox(height: 30,),
              Text("Sharing is Caring !!!",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                wordSpacing: 2
              ),),
              SizedBox(height: 20,),
              RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                  textColor: Colors.white,
                  color: HexColor("#339F38"),
                  child: Text("Invite Friends",style: TextStyle(
                    wordSpacing: 2,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),),
                  onPressed: (){
                    final RenderBox box = context.findRenderObject();
                    Share.share(
                        link+"\nCheckout this awesome complete pet management solution ...",
                        subject: subject,
                        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
                    );
                  }
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}





