import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/common_widgets/form_submit_button.dart';
import 'package:petmet_app/main.dart';

class PhoneSignInForm extends StatefulWidget {
  @override
  _PhoneSignInFormState createState() => _PhoneSignInFormState();
}

class _PhoneSignInFormState extends State<PhoneSignInForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String get _phone => ('+91' + _phoneController.text);
  String get _code => _codeController.text;

  bool _submitted = false;
  bool _isLoading =false;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  void _register(){
    _phone.length == 13
        ? _loginUser(_phone.trim(), context)
        : setState(() { _submitted = true; });
  }

  void _showSignInError(BuildContext context,String message)
  {
    showPlatformDialog(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: Text('Sign In Failed'),
          content: Text(message),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText('OK'),
              onPressed: Navigator.of(context).pop,
            )
          ],
        );
      },
    );
  }

  Future<void> _manualCodeCheck(String verificationId) async {
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: _code);
          try {
            AuthResult result =
                await FirebaseAuth.instance.signInWithCredential(credential);
            print(result.user.uid);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } on PlatformException catch (e) {
            print(e.toString());
            _showSignInError(context, e.message);
          }
      }


  Future<void> _loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    setState(() { _isLoading=true; });

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 30),
      verificationCompleted: (AuthCredential credential) async {
        try {
          final authResult = await _auth.signInWithCredential(credential);
          print('Automatic ${authResult.user.uid}');
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } catch (e) {
          print(e.toString());
          _showSignInError(context, e.message);
        } finally
        {
          setState(() { _isLoading=false; });
        }

        //This callback would get called when verification is done automatically
      },
      verificationFailed: (AuthException e) {
        print(
            'Automatically failed with code \n ${e.code} \n and message \n ${e.message}');

        _showSignInError(context, e.message);
        setState(() { _isLoading=false; });

      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        setState(() { _isLoading=false; });
        showPlatformDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return PlatformAlertDialog(
                title: Text('Enter OTP'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PlatformTextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  ],
                ),
                actions: <Widget>[
                  PlatformDialogAction(
                    child: PlatformText("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  PlatformDialogAction(
                    child: PlatformText("Confirm"),
                    onPressed: () {
                      _manualCodeCheck(verificationId);
                    },
                  ),
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (String empty) {
        print("Automatic Verification timed out");
      },
    );
  }

  List<Widget> _buildChildren() {
    bool _displayError = _phone.length != 13 && _submitted;
    if(_isLoading)
    {
      return <Widget> [
        Center(
          child: CircularProgressIndicator(),
        )
      ];
    }
    else
      {return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 10,
                        
                        offset: Offset(
                          0,
                          2
                        )
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  onChanged: (phone) => _updateState(),
                  onEditingComplete: _register ,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Color(0xFF36A9CC),
                        width: 2,
                      ),
                    ),
                    icon: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(pW(17), 0, 0, 0),
                      child: Icon(Icons.phone_iphone,color: petColor),
                    ),
                    contentPadding:
                    EdgeInsetsDirectional.fromSTEB(pW(6), pH(12), 0, pH(12)),
                    counterStyle: TextStyle(fontSize: 15),
                    labelText: 'Enter Mobile No.',
                    hintText: '+91XXXXXXXXXX',
                    errorText: _displayError ? 'Phone Number Invalid' : null,
                  ),
                ),
              ),
            ),
          ],
        ),
        /*TextField(
          controller: _phoneController,
          decoration: InputDecoration(
            icon: Icon(Icons.phone_iphone,color: petColor),
            labelText: 'Phone Number',
            hintText: 'XXXXXXXXXX',
            errorText: _displayError ? 'Phone Number Invalid' : null,
          ),
          onChanged: (phone) => _updateState(),
          keyboardType: TextInputType.phone,
          onEditingComplete: _register ,
        ),*/
        SizedBox(height: pH(30)),
        FormSubmitButton(
          text: 'Get OTP',
          onPressed: _register,
        ),
      ];
      }
  }

  //TODO Add loading state after register button is clicked

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
