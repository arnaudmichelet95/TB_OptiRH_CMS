import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:optirh_flutter/helpers/validation_helpers.dart';

/// FormsHelpers class, contains methods to validate forms field, will return an error message if required
class FormsHelpers {
  /// Validates an email address, will return an error message if empty or invalid
  static String? validateEmail(BuildContext context, String email) {
    final AppLocalization loc = AppLocalization.of(context);
    String? rv;
    if (email.isEmpty) {
      rv = loc.getTranslation("ERR_EMAIL_EMPTY");
    } else if (!ValidationHelpers.isEmailValid(email)) {
      rv = loc.getTranslation("ERR_EMAIL_INVALID");
    }
    return rv;
  }

  /// Validates a password for login
  static String? validatePasswordForLogin(
      BuildContext context, String password) {
    final AppLocalization loc = AppLocalization.of(context);
    String? rv;
    if (password.isEmpty) {
      rv = loc.getTranslation("ERR_PASS_EMPTY");
    }
    return rv;
  }

  /// Validates a field's value that must not be empty
  static String? validateNonEmptyField(BuildContext context, String value) {
    final AppLocalization loc = AppLocalization.of(context);
    String? rv;
    if (value.isEmpty) {
      rv = loc.getTranslation("ERR_EMPTY_FIELD");
    }
    return rv;
  }

  /// Validates a password for sign up: according to the globals criteria, will return an error message if the password does not match the requirements
  static String? validatePasswordForSignUp(
      BuildContext context, String password) {
    final AppLocalization loc = AppLocalization.of(context);
    String? rv = validatePasswordForLogin(context, password);
    if (!ValidationHelpers.isPasswordValid(password)) {
      rv = loc.getTranslation("ERR_PASS_INVALID");
      rv = rv.replaceAll("MIN_CHARS", PasswordConstraints.minChars.toString());
      rv = rv.replaceAll("MAX_CHARS", PasswordConstraints.maxChars.toString());
      String specs = loc.getTranslation("PASS_SPEC_NONE");
      if (PasswordConstraints.lettersRequired) {
        specs = loc.getTranslation("PASS_SPEC_LETTERS");
      }
      if (PasswordConstraints.ulCaseRequired) {
        specs = loc.getTranslation("PASS_SPEC_LETTERS_UL");
      }
      if (PasswordConstraints.passNumbersReq) {
        specs =
            "$specs ${loc.getTranslation("AND")} ${loc.getTranslation("PASS_SPEC_NUMBERS")}";
      }
      if (PasswordConstraints.symbolsRequired) {
        specs =
            "$specs ${loc.getTranslation("AND")} ${loc.getTranslation("PASS_SPEC_SYMBOLS").replaceAll("SPECIAL_CHARS", PasswordConstraints.authorizedSymbols)}";
      }
      rv = rv.replaceAll("SPECS", specs);
      rv = "$rv.";
    }
    return rv;
  }
}
