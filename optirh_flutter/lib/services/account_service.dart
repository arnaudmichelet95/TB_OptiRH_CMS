import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:optirh_flutter/models/account.dart';
import 'package:optirh_flutter/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AccountService class, contains all methods related to the accounts
class AccountService {
  /// Tries to log in an existing account by it's email and it's password
  static Future<Account?> tryLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse("${APIService.apiURL}login/"),
      headers: await APIService.header,
      body: json.encode({'username': email, 'password': password}),
    );
    if (response.statusCode == HTTPStatusCodes.ok) {
      String responseBody = response.body;
      String decodedData = utf8.decode(responseBody.runes.toList());
      await (await SharedPreferences.getInstance()).setString(
          'auth_token', json.decode(response.body)['token'].toString());
      return Account.fromJson(json.decode(decodedData)['user']);
    } else {
      return null;
    }
  }

  /// Tries to sign up and create a new account
  static Future<Account?> trySignUp(String email, String password) async {
    final response = await http.post(
      Uri.parse("${APIService.apiURL}register/"),
      headers: await APIService.header,
      body: json.encode({'username': email, 'password': password}),
    );
    if (response.statusCode == HTTPStatusCodes.created) {
      String responseBody = response.body;
      String decodedData = utf8.decode(responseBody.runes.toList());
      await (await SharedPreferences.getInstance()).setString(
          'auth_token', json.decode(response.body)['token'].toString());
      return Account.fromJson(json.decode(decodedData)['user']);
    } else {
      return null;
    }
  }

  /// Logs out a connected account
  static Future<bool> logout() async {
    final response = await http.post(
      Uri.parse("${APIService.apiURL}logout/"),
      headers: await APIService.header,
    );
    bool result = response.statusCode == HTTPStatusCodes.ok;
    if (result) {
      result =
          await (await SharedPreferences.getInstance()).remove('auth_token');
    }
    return result;
  }
}
