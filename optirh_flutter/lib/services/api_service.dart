import 'package:optirh_flutter/helpers/globs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// APIService class, provides all attributes common to all services
class APIService {
  /// Gets the Django API URL
  static String get apiURL {
    return AppConfiguration.isDev
        ? AppConfiguration.devAPIURL
        : AppConfiguration.prodAPIURL;
  }

  /// Gets the default json header
  static Future<Map<String, String>> get header async {
    String? token =
        (await SharedPreferences.getInstance()).getString(Globs.authTokenKey);
    Map<String, String> rv = {'Content-Type': 'application/json'};
    if (token != null) {
      rv['Authorization'] = 'Token $token';
    }
    return rv;
  }
}
