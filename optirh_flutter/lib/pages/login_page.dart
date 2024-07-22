import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/account_manager.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/forms_helpers.dart';
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:optirh_flutter/helpers/validation_helpers.dart';
import 'package:optirh_flutter/pages/base_page.dart';
import 'package:optirh_flutter/pages/signup_page.dart';
import 'package:optirh_flutter/widgets/button_widget.dart';
import 'package:optirh_flutter/widgets/labelled_text_field_widget.dart';
import 'package:optirh_flutter/widgets/rectangular_container_widget.dart';
import 'package:optirh_flutter/widgets/simple_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late bool _emailValid = false;
  late bool _passValid = false;

  void _handleLogin() async {
    if (_emailValid && _passValid) {
      AppLocalization loc = AppLocalization.of(context);
      AccountManager manager = AccountManager.getInstance();
      bool ok = await manager.tryLogin(_emailController.text, _passController.text);
      if (ok) {
        _handleSuccessLogin(manager, loc);
      } else {
        _handleFailedLogin(loc);
      }
    }
  }

  void _handleFailedLogin(AppLocalization loc) {
    SimpleSnackBar.showSnackBar(context, loc.getTranslation("LOGIN_ERR_MSG"));
    _passController.text = "";
  }

  void _handleSuccessLogin(AccountManager manager, AppLocalization loc) {
    SimpleSnackBar.showSnackBar(
      context,
      loc.getTranslation("LOGIN_SUCCESS_MSG").replaceAll("EMAIL", manager.getConnectedAccount().email),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BasePage(),
      ),
      (route) => false,
    );
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
                    return FormsHelpers.validatePasswordForLogin(context, value);
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
