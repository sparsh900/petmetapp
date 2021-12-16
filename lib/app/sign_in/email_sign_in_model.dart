import 'package:petmet_app/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
    this.formType = EmailSignInFormType.signIn,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;
  final EmailSignInFormType formType;

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an Account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an Account? Sign In';
  }

  bool get canSubmit {
    return (emailValidator.isNotEmpty(email) &&
            passwordValidator.isNotEmpty(password)) &&
        (!submitted ||
            (emailValidator.isValid(email) &&
                passwordValidator.isValid(password))) &&
        !isLoading;
  }

  String get passwordErrorText {
    return submitted && !passwordValidator.isValid(password)
        ? invalidPasswordErrorText
        : null;
  }

  String get emailErrorText {
    return submitted && !emailValidator.isValid(email)
        ? invalidEmailErrorText
        : null;
  }

  EmailSignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
    EmailSignInFormType formType,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
      formType: formType ?? this.formType,
    );
  }
}
