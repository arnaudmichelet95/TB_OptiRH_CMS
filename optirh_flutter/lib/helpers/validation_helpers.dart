import 'package:optirh_flutter/helpers/globs.dart';

/// ValidationHelpers class, contains static methods to validate data.
class ValidationHelpers {
  /// Checks if an email address is valid
  static bool isEmailValid(String email) {
    return Regex.email.hasMatch(email);
  }

  /// Checks if a password is valid
  static bool isPasswordValid(String password) {
    bool lengthOk = password.length >= PasswordConstraints.minChars &&
        password.length <= PasswordConstraints.maxChars;
    bool lettersOk = true;
    if (PasswordConstraints.lettersRequired) {
      lettersOk = Regex.lowerCase.hasMatch(password) ||
          Regex.upperCase.hasMatch(password);
    }
    bool numbersOk = true;
    if (PasswordConstraints.passNumbersReq) {
      numbersOk = Regex.numbers.hasMatch(password);
    }
    bool symbolsOk = true;
    if (PasswordConstraints.symbolsRequired) {
      symbolsOk = Regex.symbols.hasMatch(password);
    }
    bool ulOk = true;
    if (PasswordConstraints.ulCaseRequired) {
      ulOk = Regex.lowerCase.hasMatch(password) &&
          Regex.upperCase.hasMatch(password);
    }
    return lengthOk && lettersOk && numbersOk && symbolsOk && ulOk;
  }
}
