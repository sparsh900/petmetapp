import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/sign_in/email_sign_in_page.dart';
import 'package:petmet_app/app/sign_in/phone_sign_in_page.dart';
import 'package:petmet_app/app/sign_in/sign_in_button.dart';
import 'package:petmet_app/app/sign_in/social_sign_in_button.dart';
import 'package:petmet_app/common_widgets/show_error_dialog.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading=false;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
    }

  int _currentIndex=0;
  List cardList=["images/undraw3.png","images/undraw2.png","images/undraw1.png","images/undraw4.png"];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }


  Widget _showAppleSignIn(bool appleSignInIsAvailable)
  {
    if(appleSignInIsAvailable)
      {
        return apple.AppleSignInButton(
          style: apple.ButtonStyle.white,
          type: apple.ButtonType.signIn,
          onPressed: () => _signInWithApple(context),
        );
      }
    else
      {
        return SocialSignInButton(
          text: 'Sign In with Facebook',
          assetName: 'images/facebook-logo.png',
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () => _signInWithFacebook(context),
        );
      }
  }

  void _showSignInError(BuildContext context,PlatformException exception)
  {
    showPlatformDialog(
      context: context,
      builder: (context) {
        return PlatformAlertDialog(
          title: Text('Sign In Failed'),
          content: Text(exception.message),
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

  Future<void> _signInAnonymously(BuildContext context) async{
    try {
      setState(() {
        _isLoading =true;
      });
      final auth=Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    } finally{
      setState(() {
        _isLoading=false;
      });
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    try {
      setState(() {
        _isLoading =true;
      });
      final auth=Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      setState(() {
        _isLoading=false;
      });
      if(e.code!='ERROR_ABORTED_BY_USER')
      {_showSignInError(context, e);}
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async{
    try {
      setState(() {
        _isLoading =true;
      });
      final auth=Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on PlatformException catch (e) {
      setState(() {
        _isLoading=false;
      });
      _showSignInError(context, e);

    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = Provider.of<AuthBase>(context, listen: false);
      final user = await authService.signInWithApple(
          scopes: [apple.Scope.email, apple.Scope.fullName]);
      print('uid: ${user.uid}');
    } catch (e) {
      print(e);
      ShowErrorDialog.show(context: context,title: 'Sign In Failed',message: e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  void _signInWithPhone(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => PhoneSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable=Provider.of<AppleSignInAvailable>(context,listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.0,
                  child: Container(
                    margin: EdgeInsets.all(8),
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
                      },
                      textColor: Colors.grey[600],
                    ),
                  ),
                ),
                Image.asset(
                  'images/petmet-appbar-logo.png',
                  width: pW(171),
                  height: pH(63),
                ),
                Container(
                  margin: EdgeInsets.all(8),
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
                      _signInAnonymously(context);
                    },
                    textColor: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, pH(55), 0, 0),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 8),
                      autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      //autoPlayCurve: Curves.fastOutSlowIn,
//                    onPageChanged: (index) {
//                      setState(() {
//                        _currentIndex = index;
//                      });
//                    },
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: cardList.map((card){
                      return Builder(
                          builder:(BuildContext context){
                            return Container(
                              child: //Card(
                                /*child:*/ Image.asset(
                                    card,
                                    //height: pW(400)
                                ),
                              );
                            //);
                          }
                      );
                    }).toList(),
                  ),
                  /*Container(
                    width: pW(248),
                    height: pH(200),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                        AssetImage('images/sign_in_page.png'),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),*/
                  SizedBox(height: pH(11)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(cardList, (index, url) {
                      return Container(
                        width: pW(5),
                        height: pH(5),
                        margin: EdgeInsets.symmetric(vertical: pH(10), horizontal: pW(8)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == index ? Color(0xFF36A9CC) : Color(0xFFCECECE),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: pH(11)),
                  Text(
                    'We care for your pet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: pH(20)),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
               // height: 800,
                color: petColor,
                  child: _isLoading? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ):SingleChildScrollView(child: _buildContent(context,appleSignInAvailable.isAvailable))
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildContent(BuildContext context,bool appleSignInIsAvailable) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 16, 30, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(context,appleSignInIsAvailable),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context,bool appleSignInIsAvailable) {
      return <Widget>[
        Text(
          'Login or Sign Up',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20.0),
        SocialSignInButton(
          text: 'Sign In with Google',
          assetName: 'images/google-logo.png',
          color: Colors.white,
          onPressed: () => _signInWithGoogle(context),
        ),
        SizedBox(height: 15.0),
        _showAppleSignIn(appleSignInIsAvailable),
        SizedBox(height: 15.0),
        SignInButton(
          icon: Icons.email,
          text: 'Sign In with email',
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () => _signInWithEmail(context),
        ),
        SizedBox(height: 15.0),
        SignInButton(
          icon: Icons.phone,
          text: 'Sign In with Phone',
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () => _signInWithPhone(context),
        ),
        SizedBox(height: 15.0),
        Text(
          'By Continuing you accept the',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
            color: Colors.white,
          ),
        ),
        InkWell(
          onTap: _launchURL,
          child: Text(
            'Terms and conditions of Pet Met',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 15.0),
      ];
  }
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await apple.AppleSignIn.isAvailable());
  }
}

_launchURL() async {
  const url = 'https://petmet.co.in/privacyPolicy';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
