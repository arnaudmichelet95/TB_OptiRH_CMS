import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/account_manager.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/forms_helpers.dart';
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:optirh_flutter/helpers/validation_helpers.dart';
import 'package:optirh_flutter/pages/base_page.dart';
import 'package:optirh_flutter/pages/login_page.dart';
import 'package:optirh_flutter/widgets/button_widget.dart';
import 'package:optirh_flutter/widgets/labelled_text_field_widget.dart';
import 'package:optirh_flutter/widgets/rectangular_container_widget.dart';
import 'package:optirh_flutter/widgets/simple_snack_bar.dart';

/// SignUpPage class, page for a new user to create an account
class SignUpPage extends StatefulWidget {
  /// Creates a new SignUpPage
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

/// SignUpPage state class
class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();
  late bool _emailValid = false;
  late bool _passValid = false;
  late bool _passConfirmValid = false;

  /// Handles the click on the sign up button
  void _handleSignUp() async {
    if (_emailValid && _passValid && _passConfirmValid) {
      AppLocalization loc = AppLocalization.of(context);
      AccountManager manager = AccountManager.getInstance();
      bool ok =
          await manager.trySignUp(_emailController.text, _passController.text);
      if (ok) {
        _handleSuccessSignUp(manager, loc);
      } else {
        _handleFailedSignUp(loc);
      }
    }
  }

  /// Sign up is a failure, show snack bar with error message
  void _handleFailedSignUp(AppLocalization loc) {
    String errorMessage = loc.getTranslation("SIGNUP_ERR_MSG");

    SimpleSnackBar.showSnackBar(
      context,
      errorMessage,
    );
    _passController.text = "";
    _passConfirmController.text = "";
  }

  /// Sign up is a success, show snack bar and redirect to home
  void _handleSuccessSignUp(AccountManager manager, AppLocalization loc) {
    SimpleSnackBar.showSnackBar(
      context,
      loc
          .getTranslation("SIGNUP_SUCCESS_MSG")
          .replaceAll("EMAIL", manager.getConnectedAccount().email),
    );
    // Remove all routes to prevent the user from getting back to the signup page and get back to the home page
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BasePage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalization loc = AppLocalization.of(context);
    return RectangularContainerWidget(
      title: loc.getTranslation("SIGNUP"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Globs.mediumSizedBox,
          Column(
            children: [
              SizedBox(
                height: Globs.averageHeight,
                width: Globs.averageWidth,
                child: LabelledTextFieldWidget(
                  label: loc.getTranslation("EMAIL"),
                  hint: loc.getTranslation("ENTER_MAIL"),
                  controller: _emailController,
                  isPassword: false,
                  validateInput: (context, value) {
                    setState(() {
                      _emailValid = ValidationHelpers.isEmailValid(value);
                    });
                    return FormsHelpers.validateEmail(context, value);
                  },
                ),
              ),
              SizedBox(
                height: Globs.averageHeight,
                width: Globs.averageWidth,
                child: LabelledTextFieldWidget(
                  label: loc.getTranslation("PASS"),
                  hint: loc.getTranslation("ENTER_PASS"),
                  controller: _passController,
                  isPassword: true,
                  validateInput: (context, value) {
                    setState(() {
                      _passValid = ValidationHelpers.isPasswordValid(value);
                    });
                    return FormsHelpers.validatePasswordForSignUp(
                        context, value);
                  },
                ),
              ),
              SizedBox(
                height: Globs.averageHeight,
                width: Globs.averageWidth,
                child: LabelledTextFieldWidget(
                  label: loc.getTranslation("PASS_CONFIRM"),
                  hint: loc.getTranslation("ENTER_PASS_CONFIRM"),
                  controller: _passConfirmController,
                  isPassword: true,
                  maxLines: 1,
                  validateInput: (context, value) {
                    String? rv;
                    bool match = _passController.text == value;
                    setState(() {
                      _passConfirmValid = match;
                    });
                    if (!match) {
                      rv = loc.getTranslation("ERR_PASS_MISMATCH");
                    }
                    return rv;
                  },
                ),
              ),
            ],
          ),
          Globs.mediumSizedBox,
          ButtonWidget(
            action: _handleSignUp,
            text: loc.getTranslation("SIGNUP"),
            enabled: _emailValid && _passValid && _passConfirmValid,
          ),
          Globs.smallSizedBox,
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ));
            },
            child: Text(loc.getTranslation("EXISTING_ACCT_LOGIN")),
          ),
        ],
      ),
    );
  }
}
