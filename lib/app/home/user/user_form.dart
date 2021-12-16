import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:petmet_app/app/home_page_skeleton.dart';
import 'package:petmet_app/app/home/models/user.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/database.dart';

class Userform extends StatefulWidget {
  Userform({@required this.database, this.userData});
  final Database database;
  final UserData userData;

  @override
  _UserformState createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  final _formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  String _address;
  String _mobileNumber;
  String _email;
  String _pincode;

  bool _isLoading = false;

  final FocusNode _myFocusNode1 = FocusNode();
  final FocusNode _myFocusNode2 = FocusNode();
  final FocusNode _myFocusNode3 = FocusNode();
  final FocusNode _myFocusNode4 = FocusNode();
  final FocusNode _myFocusNode5 = FocusNode();
  final FocusNode _myFocusNode6 = FocusNode();

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _myFocusNode1.dispose();
    _myFocusNode2.dispose();
    _myFocusNode3.dispose();
    _myFocusNode4.dispose();
    _myFocusNode5.dispose();
    _myFocusNode6.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xE5E5E5),
            padding: EdgeInsetsDirectional.fromSTEB(pW(18), pH(72), pW(24), 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLogoBar(context),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, pH(51), 0, 22),
                  child: Center(
                    child: Text(
                      'Set Up Your Profile',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _buildForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildLogoBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'images/petmet-appbar-logo.png',
          width: pW(171),
          height: pH(63),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border.all(
                  color: Colors.grey,
                ),
              ),
              height: pH(24.0),
              width: pW(74.0),
              child: FlatButton(
                child: Center(
                  child: Text(
                    'SKIP',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Colors.grey[600],
              ),
            ),
            Container(
              height: pH(22.0),
              width: pW(66.0),
            )
          ],
        ),
      ],
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _firstName,
                    onSaved: (value) => _firstName =
                        value.substring(0, 1).toUpperCase() +
                            value.substring(1),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'First Name can\'t be empty',
                    focusNode: _myFocusNode1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode2),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your First Name',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _lastName,
                    onSaved: (value) => _lastName =
                        value.substring(0, 1).toUpperCase() +
                            value.substring(1),
                    validator: (value) =>
                        value.isNotEmpty ? null : 'Last Name can\'t be empty',
                    focusNode: _myFocusNode2,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode3),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your Last Name',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _address,
                    onSaved: (value) => _address = value,
                    validator: (value) => value.isNotEmpty
                        ? null
                        : 'Address Name can\'t be empty',
                    focusNode: _myFocusNode3,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode4),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your Address',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "",
                style: TextStyle(fontSize: 20),
              ),
              //SizedBox(width: 5),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    enabled: widget.database.getEmail() != null &&
                            widget.database.getEmail().contains('+91')
                        ? false
                        : true,
                    initialValue: widget.database.getEmail() != null &&
                            widget.database.getEmail().contains('+91')
                        ? widget.database.getEmail().substring(3)
                        : _mobileNumber,
                    onSaved: (value) => _mobileNumber = "91" + value,
                    validator: (value) =>
                        value.length == 10 ? null : 'Enter valid Mobile Number',
                    focusNode: _myFocusNode4,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode5),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your Mobile Number',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    enabled: widget.database.getEmail() != null &&
                            widget.database.getEmail().contains('@')
                        ? false
                        : true,
                    initialValue: widget.database.getEmail() != null &&
                            widget.database.getEmail().contains('@')
                        ? widget.database.getEmail()
                        : _email,
                    onSaved: (value) => _email = value,
                    validator: (value) =>
                        value.contains('@') && value.contains(".")
                            ? null
                            : 'Enter Valid Email',
                    focusNode: _myFocusNode5,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_myFocusNode6),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your Email',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(21)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      boxShadow: [
                        new BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 20.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6)),
                  child: TextFormField(
                    initialValue: _pincode,
                    onSaved: (value) => _pincode = value,
                    validator: (value) =>
                        value.length == 6 ? null : 'Enter Valid Pincode',
                    focusNode: _myFocusNode6,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(54, 169, 204, 1),
                          width: 3,
                        ),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(13, 17, 0, 17),
                      counterStyle: TextStyle(fontSize: 15),
                      labelText: 'Enter Your Pincode',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: pH(20)),
          Text(
            'Note: All fields are mandatory',
            style: TextStyle(
              color: metColor,
            ),
          ),
          SizedBox(height: pH(40)),
          Row(children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsetsDirectional.fromSTEB(0, 11, 0, 11),
                color: Color.fromRGBO(54, 169, 204, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  'SAVE & PROCEED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: _submit,
              ),
            ),
          ]),
          SizedBox(height: pH(22)),
          Center(
            child: Image.asset(
              'images/petmet-translucent-logo.png',
              width: pW(140),
              height: pH(140),
            ),
          ),
        ],
      ),
    );
  }

  //Form Business logic

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  bool validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future<void> _checkUserData(Database database) async {
    bool ans = await database.checkUserData();

    if (!mounted) return;

    if (ans) {
      checkUserAns = true;
    } else {
      checkUserAns = false;
    }
  }

  Future<void> _submit() async {
    if (validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final userData = UserData(
          firstName: _firstName,
          lastName: _lastName,
          address: _address,
          phone: _mobileNumber,
          mail: _email,
          zip: _pincode,
          usedPromo: [],
          walletMoney: 0,
          walletHistory: [],
          secondaryAddresses: [
            {
              'address': _address,
              'name': _firstName + ' ' + _lastName,
              'zip': _pincode,
              'phone': _mobileNumber,
            }
          ],
        );
        final deviceToken = await fcm.getToken();
        await widget.database.setUserData(userData, deviceToken);
        await _checkUserData(widget.database);
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        ShowErrorDialog.show(
          context: context,
          title: 'Adding Pet Failed',
          message: e.toString(),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
