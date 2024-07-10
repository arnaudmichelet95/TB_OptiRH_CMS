import 'package:flutter/material.dart';

/// Contains all globals that will directly impact the application functioning
class AppConfiguration {
  /// Application name
  static const String appName = "TB Opti RH";

  /// Application state, must be edited manually before deployment!
  static const bool isDev = true;

  /// Development API URL
  static const String devAPIURL = "http://localhost:8000/optirh_app/api/";

  /// Production API URL
  static const String prodAPIURL =
      "http://vlhprj645docker.hevs.ch:8000/optirh_app/api/";

  /// Default database separator for concatened arrays
  static const String defaultDBSeparator = ";";
}

/// Contains all the constraints applied for each account creation
class PasswordConstraints {
  /// Minimum characters for the passwords
  static const int minChars = 8;

  /// Maximum characters for the passwords
  static const int maxChars = 30;

  /// Letters required in passwords
  static const bool lettersRequired = true;

  /// Numbers required in passwords
  static const bool passNumbersReq = true;

  /// Symbols required in passwords
  static const bool symbolsRequired = true;

  /// Upper-case and lower-case required in passwords
  static const bool ulCaseRequired = true;

  /// Symbols authorized in passwords
  static const String authorizedSymbols = '!@#\$%^&*(),.?":{}|<>';
}

/// Contains all HTTP status codes used in the application
class HTTPStatusCodes {
  /// HTTP status code 200 : ok
  static const int ok = 200;

  /// HTTP status code 201 : created
  static const int created = 201;

  /// HTTP status code 400 : bad request
  static const int badRequest = 400;

  /// HTTP status code 401 : unauthorized
  static const int unauthorized = 401;
}

/// Contains all Regex used in the application
class Regex {
  /// Regex for email validation
  static final RegExp email = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    caseSensitive: false,
    multiLine: false,
  );

    /// Regex for numbers
  static final RegExp numbers = RegExp(r'\d');

  /// Regex for symbols
  static final RegExp symbols =
      RegExp('[${PasswordConstraints.authorizedSymbols}]');

  /// Regex for lower case letters
  static final RegExp lowerCase = RegExp(r'[a-z]');

  /// Regex for upper case letters
  static final RegExp upperCase = RegExp(r'[A-Z]');
}

class Globs {
  /// Application font family
  static const String appFontFamily = "Montserrat";
}