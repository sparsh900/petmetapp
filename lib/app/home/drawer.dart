import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/home/pets/pet_form.dart';

import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/user/user_form.dart';
import 'package:petmet_app/app/hostel/hostel_bookings.dart';
import 'package:petmet_app/app/manageAddresses/manageAddresses.dart';
import 'package:petmet_app/app/notification.dart';
import 'package:petmet_app/app/shop_ecom/previous_orders/previousOrders.dart';
import 'package:petmet_app/app/shop_ecom/wallet/walletcash.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/personal_vet_page/my_appointments.dart';
import 'package:petmet_app/app/settings.dart';

import 'package:petmet_app/app/shop_ecom/wishlist/wishlist.dart';
import 'package:petmet_app/app/trainers/trainerSubs.dart';

import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:petmet_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer {
  static show(
      {@required Database database,
      @required BuildContext context,
      @required bool checkUserAns}) {
    double pH(double height) {
      return MediaQuery.of(context).size.height * (height / 896);
    }

    double pW(double width) {
      return MediaQuery.of(context).size.width * (width / 414);
    }

    Future<void> _signOut(BuildContext context) async {
      try {
        final auth = Provider.of<AuthBase>(context, listen: false);
        await auth.signOut();
        globalCurrentPet = null;
        globalCurrentPetValue = 0;
        checkUserAns = false;
      } catch (e) {
        print(e.toString());
      }
    }

    _launchURL() async {
      const url = 'https://petmet.co.in';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<void> _confirmSignOut(BuildContext context) async {
      final _userInput = await showPlatformDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PlatformAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            PlatformDialogAction(
              child: PlatformText('Logout'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
      if (_userInput == true) {
        _signOut(context);
      }
    }

    NetworkImage _globalPetImage = globalCurrentPet == null
        ? null
        : (globalCurrentPet.image == null
            ? null
            : NetworkImage(globalCurrentPet.image));

    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  pW(27), pH(20), pW(26), pH(14)),
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => Petform(
                        database: database,
                        uid: database.getUid(),
                        pet: globalCurrentPet,
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: pW(63),
                            width: pW(63),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              image: _globalPetImage == null
                                  ? null
                                  : DecorationImage(
                                      image: _globalPetImage,
                                      fit: BoxFit.fitWidth),
                            ),
                            child: _globalPetImage == null
                                ? Icon(
                                    Icons.pets,
                                    color: Colors.brown,
                                    size: 40,
                                  )
                                : Container(),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                pW(14), pH(18), 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                    globalCurrentPet == null
                                        ? "Add a pet"
                                        : globalCurrentPet.name,
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w500,
                                      fontSize: pH(28),
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                  if (globalCurrentPet != null)
                                    ButtonTheme(
                                      minWidth: pW(72),
                                      height: pH(22),
                                      child: FlatButton(
                                        child: new Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                            color: Color(0xFFB5B5B5),
                                            fontWeight: FontWeight.w500,
                                            fontSize: pH(14),
                                            fontStyle: FontStyle.normal,
                                            fontFamily: "Montserrat",
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => Petform(
                                                database: database,
                                                uid: database.getUid(),
                                                pet: globalCurrentPet,
                                              ),
                                            ),
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xFFB5B5B5),
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                      ),
                                    ),
                                  if (globalCurrentPet == null)
                                    SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF868686),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!checkUserAns)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(24), 0, 0),
              child: Container(
                // decoration: BoxDecoration(
                //     border: Border(
                //         bottom:
                //             BorderSide(width: 1, color: Color(0xFF868686)))),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                  child: ListTile(
                      title: Text(
                        database.getEmail() != null
                            ? "Update Profile"
                            : "Create Profile",
                        style: TextStyle(
                          color: metColor,
                          fontWeight: FontWeight.w600,
                          fontSize: pH(22),
                          fontStyle: FontStyle.normal,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: pH(20),
                      ),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => Userform(database: database),
                          ),
                        );
                      }),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(22),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: pH(20),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NotificationsPage(database: database),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "My Appointments",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      if (globalCurrentPet == null) {
                        ShowErrorDialog.show(
                            context: context,
                            title: 'No Pet Found',
                            message: 'Please add a Pet to continue');
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyAppointmentsPage(database: database)),
                        );
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "My Subscriptions",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      if (globalCurrentPet == null) {
                        ShowErrorDialog.show(
                            context: context,
                            title: 'No Pet Found',
                            message: 'Please add a Pet to continue');
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowTrainerSubscriptions(database: database)),
                        );
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "My Hostel Bookings",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                HostelBookings(database: database)),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "Previous Orders",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      // if(globalCurrentPet == null)
                      // {
                      //   ShowErrorDialog.show(context: context,title: 'No Pet Found',message: 'Please add a Pet to continue');
                      // }
                      // else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                PreviousOrders(database: database)),
                      );
                      //}
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "Wishlist",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(builder: (context) {
                        return Wishlist(database: database);
                      }));
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(

              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "Wallet Money",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () async {
                      if (checkUserAns) {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => WalletCash(
                                    database: database,
                                  )),
                        );
                      } else {
                        await ShowErrorDialog.show(
                            context: context,
                            message: 'Please Update profile to continue',
                            title: 'Profile Incomplete');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Userform(database: database)));
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(34), 0, 0, 0),
            child: Divider(
              color: Color(0xFFBDBDBD),
              thickness: 0.5,
            ),
          ),
          /*Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(6), 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                    title: Text(
                      "Pet Adoption",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => AdoptionHomepage(
                            database: database,
                            uid: database.getUid(),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(3), 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                    title: Text(
                      "Dog Walker",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      if (globalCurrentPet == null) {
                        ShowErrorDialog.show(
                            context: context,
                            title: 'No Pet Found',
                            message: 'Please add a Pet to continue');
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => DogWalkerHomepage(
                                    database: database,
                                    uid: database.getUid(),
                                  )),
                        );
                      }
                    }),
              ),
            ),
          ),*/
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(8), pH(4), 0, 0),
            child: Container(
              // decoration: BoxDecoration(
              //     border: Border(
              //         bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(0)),
                child: ListTile(
                    title: Text(
                      "Manage Address",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    /*trailing: Icon(Icons.arrow_forward_ios,
                                    size: pH(20),
                                  ),
                                  onTap: () {
                                    if(globalCurrentPet == null)
                                    {
                                      ShowErrorDialog.show(context: context,title: 'No Pet Found',message: 'Please add a Pet to continue');
                                    }
                                    else {
                                      Navigator.of(context, rootNavigator: true).push(
                                        MaterialPageRoute(builder: (context) =>
                                            MyAppointmentsPage(database: database)),
                                      );
                                    }
                                  }*/

                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () async {
                      if (checkUserAns) {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => ManageAddress(
                                    database: database,
                                    isManageAddress: true,
                                  )),
                        );
                      } else {
                        await ShowErrorDialog.show(
                            context: context,
                            message: 'Please Update profile to continue',
                            title: 'Profile Incomplete');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Userform(database: database)));
                      }
                    }),
              ),
            ),
          ),

          Container(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(30), pH(32), 0, pH(24)),
              child: InkWell(
                onTap: () async {
                  final Email email = Email(
                    body: 'Type Feedback Here',
                    subject: 'Feedback for PetMet Vendors App',
                    recipients: ['info.petmet@gmail.com'],
                    isHTML: false,
                  );

                  await FlutterEmailSender.send(email);
                },
                child: Text(
                  "Send Feedback",
                  style: TextStyle(
                    fontSize: pH(18),
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    //letterSpacing: 4
                  ),
                ),
              ),
            ),
          ),
          //Will add after app store push
          // Container(
          //   child: Padding(
          //     padding: EdgeInsetsDirectional.fromSTEB(pW(30), pH(0), 0, pH(24)),
          //     child: InkWell(
          //       onTap: _rateApp,
          //       child: Text(
          //         Platform.isIOS?"Rate us on App Store":"Rate us on Play Store",
          //         style: TextStyle(
          //           fontSize: pH(18),
          //           color: Color(0xFF757575),
          //           fontWeight: FontWeight.w400,
          //           fontStyle: FontStyle.normal,
          //           fontFamily: 'Roboto',
          //           //letterSpacing: 4
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(pW(30), pH(0), 0, pH(24)),
              child: InkWell(
                onTap: () => _confirmSignOut(context),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: pH(18),
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    //letterSpacing: 4
                  ),
                ),
              ),
            ),
          ),

          /*Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(3), 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                    title: Text(
                      "Refer a Friend",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontSize: pH(22),
                        fontStyle: FontStyle.normal,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: pH(20),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => ReferScreen()),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(3), 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                  title: Text(
                    "About us",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(22),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: pH(20),
                  ),
                  onTap: _launchURL,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(3), 0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                  title: Text(
                    "Need Help",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(22),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: pH(20),
                  ),
                  onTap: () async {
                    final Email email = Email(
                      body: 'Type Your Problem Here',
                      subject: 'Help for PetMet App',
                      recipients: ['info.petmet@gmail.com'],
                      isHTML: false,
                    );

                    await FlutterEmailSender.send(email);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(pW(33), pH(3), 0, 0),
            child: Container(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, pW(6), pH(1)),
                child: ListTile(
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontSize: pH(22),
                      fontStyle: FontStyle.normal,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  trailing: Icon(
                    Icons.exit_to_app,
                    size: pH(20),
                  ),
                  onTap: () => _confirmSignOut(context),
                ),
              ),
            ),
          ),*/
          Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Color(0xFF868686)))),
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: new IconTheme(
                            data: new IconThemeData(color: Color(0xFF63A9CC)),
                            child: Icon(Icons.settings),
                          ),
                          title: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(pW(18), 0, 0, 0),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                fontSize: pH(22),
                                fontStyle: FontStyle.normal,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                          onTap: () async {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) => SettingPage(
                                        database: database,
                                      )),
                            );
                          }),
                    ],
                  ))),
        ],
      ),
    );
  }
}
