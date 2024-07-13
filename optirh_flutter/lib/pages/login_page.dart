import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/account_manager.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/forms_helpers.dart';
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:optirh_flutter/helpers/validation_helpers.dart';
import 'package:optirh_flutter/pages/home_page.dart';
import 'package:optirh_flutter/pages/signup_page.dart';
import 'package:optirh_flutter/widgets/button_widget.dart';
import 'package:optirh_flutter/widgets/labelled_text_field_widget.dart';
import 'package:optirh_flutter/widgets/rectangular_container_widget.dart';
import 'package:optirh_flutter/widgets/simple_snack_bar.dart';

/// LoginPage class, page for an existing user to log in
class LoginPage extends StatefulWidget {
  /// Creates a new LoginPage
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// LoginPage state class
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late bool _emailValid = false;
  late bool _passValid = false;

  /// Handles the click on the login button
  void _handleLogin() async {
    if (_emailValid && _passValid) {
      AppLocalization loc = AppLocalization.of(context);
      AccountManager manager = AccountManager.getInstance();
      bool ok =
          await manager.tryLogin(_emailController.text, _passController.text);
      if (ok) {
        _handleSuccessLogin(manager, loc);
      } else {
        _handleFailedLogin(loc);
      }
    }
  }

  /// Login is a failure, show snack bar with error message
  void _handleFailedLogin(AppLocalization loc) {
    SimpleSnackBar.showSnackBar(context, loc.getTranslation("LOGIN_ERR_MSG"));
    _passController.text = "";
  }

  /// Login is a success, show snack bar and redirect to home
  void _handleSuccessLogin(AccountManager manager, AppLocalization loc) {
    SimpleSnackBar.showSnackBar(
      context,
      loc
          .getTranslation("LOGIN_SUCCESS_MSG")
          .replaceAll("EMAIL", manager.getConnectedAccount().email),
    );
    // Remove all routes to prevent the user from getting back to the login page and get back to the home page
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    final theme = Theme.of(context);
    return RectangularContainerWidget(
      title: loc.getTranslation("LOGIN"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Globs.mediumSizedBox,
          Column(
            children: [
              Container(
                color: theme.colorScheme.onSurface,
                height: Globs.averageHeight,
                width: Globs.averageWidth,
                child: LabelledTextFieldWidget(
                  label: loc.getTranslation("EMAIL"),
                  hint: loc.getTranslation("ENTER_MAIL"),
                  controller: _emailController,
                  isPassword: false,
                  maxLines: 1,
                  validateInput: (context, value) {
                    setState(() {
                      _emailValid = ValidationHelpers.isEmailValid(value);
                    });
                    return FormsHelpers.validateEmail(context, value);
                  },
                ),
              ),
              Container(
                color: theme.colorScheme.onSurface,
                height: Globs.averageHeight,
                width: Globs.averageWidth,
                child: LabelledTextFieldWidget(
                  label: loc.getTranslation("PASS"),
                  hint: loc.getTranslation("ENTER_PASS"),
                  controller: _passController,
                  isPassword: true,
                  maxLines: 1,
                  validateInput: (context, value) {
                    setState(() {
                      _passValid = value.isNotEmpty;
                    });
                    return FormsHelpers.validatePasswordForLogin(
                        context, value);
                  },
                ),
              ),
            ],
          ),
          Globs.mediumSizedBox,
          ButtonWidget(
            action: _handleLogin,
            text: loc.getTranslation("LOGIN"),
            enabled: _emailValid && _passValid,
          ),
          Globs.smallSizedBox,
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SignUpPage(),
              ));
            },
            child: Text(loc.getTranslation("NO_ACCT_SIGNUP")),
          ),
        ],
      ),
    );
  }
}
