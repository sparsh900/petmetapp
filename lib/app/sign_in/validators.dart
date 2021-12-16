import 'package:flutter/services.dart';

abstract class StringValidator {
  bool isValid(String value);
  bool isNotEmpty(String value);
}

class EmailValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty && value.contains('@') && value.contains('.');
  }

  bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }
}

class PassValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty &&
        (value.length >= 8) &&
        value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = EmailValidator();
  final StringValidator passwordValidator = PassValidator();
  final String invalidEmailErrorText = 'Invalid Email';
  final String invalidPasswordErrorText =
      'Invalid Password (Min 8 Character including 1 Special)';

  static String message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_INVALID_EMAIL': 'The email address is invalid',
    'ERROR_WRONG_PASSWORD': 'The password is incorrect',
    'ERROR_USER_NOT_FOUND': 'No user found',
    'ERROR_WEAK_PASSWORD': 'Password should have minimum 8 characters including a special character',

    ///  * `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///  * `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///  * `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
    ///  * `ERROR_INVALID_EMAIL` - If the email address is malformed.
    ///  * `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
  };
}
