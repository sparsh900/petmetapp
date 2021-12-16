import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:petmet_app/app/sign_in/email_sign_in_bloc.dart';
import 'package:petmet_app/app/sign_in/email_sign_in_model.dart';
import 'package:petmet_app/app/sign_in/validators.dart';
import 'package:petmet_app/common_widgets/form_submit_button.dart';
import 'package:petmet_app/main.dart';
import 'package:petmet_app/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of(context, listen: false);
    return Provider(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInForm(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _passHidden = true;

  double pH(double height) {
    return MediaQuery.of(context).size.height * (height / 896);
  }

  double pW(double width) {
    return MediaQuery.of(context).size.width * (width / 414);
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _submit(EmailSignInModel model) async {
    print(
        'email : ${_emailController.text}, password: ${_passwordController.text}');
    if(model.emailValidator.isValid(model.email) && model.passwordValidator.isValid(model.password)) {
      try {
        await widget.bloc.submit();
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        print(e.toString());
        showPlatformDialog(
          context: context,
          builder: (context) {
            return PlatformAlertDialog(
              title: Text('Sign In Failed'),
              content: Text(EmailAndPasswordValidators.message(e)),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('OK'),
                  onPressed: Navigator
                      .of(context)
                      .pop,
                )
              ],
            );
          },
        );
      }
    }
    else
      {
        widget.bloc.updateSubmitted();
      }
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      SizedBox(height: pH(20)),
      _buildEmailTextField(model),
      SizedBox(height: pH(16)),
      _buildPasswordTextField(model),
      SizedBox(height: pH(26)),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? ()=>_submit(model) : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: model.isLoading ? null : _toggleFormType,
      ),
    ];
  }

  Row _buildPasswordTextField(EmailSignInModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2)),
                ],
                borderRadius: BorderRadius.circular(6)),
            child: TextFormField(
              obscureText: _passHidden,
              textInputAction: TextInputAction.done,
              onChanged: widget.bloc.updatePassword,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      _passHidden = !_passHidden;
                    });
                  },
                  child: _passHidden
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
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
                  child: Icon(Icons.lock_open, color: petColor),
                ),
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(pW(6), pH(16), 0, pH(16)),
                counterStyle: TextStyle(fontSize: 15),
                labelText: 'Password',
                errorText: model.passwordErrorText,
                enabled: model.isLoading == false,
                //errorText: _displayError ? 'Phone Number Invalid' : null,
              ),
            ),
          ),
        ),
      ],
    );
    /*TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        icon: Icon(Icons.lock_open,color: petColor),
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );*/
  }

  Row _buildEmailTextField(EmailSignInModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2)),
                ],
                borderRadius: BorderRadius.circular(6)),
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _emailEditingComplete(model),
              onChanged: widget.bloc.updateEmail,
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
                    child: Icon(Icons.email, color: petColor),
                  ),
                  contentPadding:
                      EdgeInsetsDirectional.fromSTEB(pW(6), pH(16), 0, pH(16)),
                  counterStyle: TextStyle(fontSize: 15),
                  labelText: 'Email',
                  hintText: 'test@test.com',
                  errorText: model.emailErrorText,
                  enabled: model.isLoading == false),
            ),
          ),
        ),
      ],
    );
    /*TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          icon: Icon(Icons.email,color: petColor),
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<EmailSignInModel>(
          stream: widget.bloc.modelStream,
          initialData: EmailSignInModel(),
          builder: (context, snapshot) {
            final EmailSignInModel model = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model),
            );
          }),
    );
  }
}
