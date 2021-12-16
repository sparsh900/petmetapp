import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/pet.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/manageAddresses/manageAddresses.dart';
import 'package:petmet_app/app/sign_in/sign_in_button.dart';
import 'package:petmet_app/common_widgets/my_flutter_app_icons.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/common_widgets/time_and_date_selector.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class BookAppointmentButton extends StatelessWidget {
  BookAppointmentButton(
      {@required this.database,
      @required this.doctorId,
      @required this.pet,
      @required this.contextPrevious});
  final Database database;
  final String doctorId;
  final Pet pet;
  final BuildContext contextPrevious;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Color(0xFFFF5352),
      onPressed: () async {
        if (pet != null) {
          if (checkUserAns) {
            _showBottomSheet(contextPrevious);
          } else {
            await ShowErrorDialog.show(
                context: context,
                title: 'Profile Incomplete',
                message: 'Please complete your profile to continue');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Userform(database: database),
            ));
          }
        } else {
          ShowErrorDialog.show(
              context: context,
              title: 'No Pet Found',
              message: 'Please add a Pet to continue');
        }
      },
      child: Container(
        height: 56,
        width: 414,
        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
        child: Text(
          "BOOK AN APPOINTMENT",
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
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 250,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'BOOK AN APPOINTMENT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                      text: 'Visit Clinic',
                      color: Colors.white,
                      textColor: Colors.black,
                      icon: Icons.home,
                      height: 45,
                      iconSize: 30,
                      textSize: 20,
                      onPressed: () => _showVisitClinicSheet(context),
                    ),
                    SizedBox(height: 20),
                    SignInButton(
                      text: 'Vet Home Visit',
                      color: Colors.white,
                      textColor: Colors.black,
                      icon: MyFlutterApp.doctor,
                      height: 45,
                      iconSize: 30,
                      textSize: 20,
                      onPressed: () {
                        if (checkUserAns) {
                          _showHomeVisitSheet(context);
                        } else {
                          ShowErrorDialog.show(
                              context: context,
                              title: 'No Addresses Found',
                              message:
                                  'Please update your profile to continue');
                        }
                      },
                    ),

                    //TODO: enable later
                    /*SignInButton(
                      text: 'Video Call',
                      color: Colors.white,
                      textColor: Colors.black,
                      icon: Icons.video_call,
                      height: 45,
                      iconSize: 30,
                      textSize: 20,
                      onPressed: () => _showVideoCallSheet(context),
                    ),
                    SignInButton(
                      text: 'Chat',
                      color: Colors.white,
                      textColor: Colors.black,
                      icon: Icons.chat_bubble_outline,
                      height: 45,
                      iconSize: 30,
                      textSize: 20,
                      onPressed: () => _showChatSheet(context),
                    ),*/
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showVisitClinicSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'CHOOSE TIME OF VISIT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TimeAndDateSelector(
                  mode: 'VisitClinic',
                  database: database,
                  doctorId: doctorId,
                  pet: pet),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHomeVisitSheet(BuildContext context) async {
    UserData user = await database.getUserData();
    Map userAddress = {
      "address":user.address,
      "phone":user.phone,
      "name": user.firstName+' '+user.lastName,
      "zip":user.zip
    };

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) =>  Container(
          height: 500,
          decoration: BoxDecoration(
            color: petColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 66,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white)),
                ),
                child: Center(
                  child: Text(
                    'CHOOSE TIME FOR HOME VISIT',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  Map addressFromManageAddress = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ManageAddress(database: database, isManageAddress: true, isVetAddress: true),
                  ));
                  if(addressFromManageAddress != null){
                    setModalState((){
                      userAddress = addressFromManageAddress;
                    });
                  }

                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    userAddress["address"],
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: TimeAndDateSelector(
                    mode: 'HomeVisit',
                    database: database,
                    doctorId: doctorId,
                    pet: pet,
                    address: userAddress["address"],
                    phone: userAddress["phone"],
                    name:userAddress["name"],
                    zip:userAddress["zip"]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
//TODO: enable later
 /* void _showVideoCallSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'CHOOSE TIME FOR VIDEO CALL',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TimeAndDateSelector(
                  mode: 'VideoCall',
                  database: database,
                  doctorId: doctorId,
                  pet: pet),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: petColor,
        ),
        child: Column(
          children: [
            Container(
              height: 66,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white)),
              ),
              child: Center(
                child: Text(
                  'CHOOSE TIME FOR CHAT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: TimeAndDateSelector(
                  mode: 'Chat',
                  database: database,
                  doctorId: doctorId,
                  pet: pet),
            ),
          ],
        ),
      ),
    );
  }*/
}
