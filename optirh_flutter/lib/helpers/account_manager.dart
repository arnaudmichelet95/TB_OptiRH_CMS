import 'package:optirh_flutter/models/account.dart';
import 'package:optirh_flutter/services/account_service.dart';

/// AccountManager class, manages the connected account
class AccountManager {
  static AccountManager? _instance;
  late Account? _account;

  /// Creates a new AccountManager instance, private constructor
  AccountManager._(this._account);

  /// Initializes an instance of the AccountManager or returns the existing one
  static AccountManager getInstance() {
    _instance ??= AccountManager._(null);
    return _instance!;
  }

  /// Returns the connected account. Will throw an exception if no account is connected
  Account getConnectedAccount() {
    if (_account == null) {
      throw Exception("No account is connected.");
    }
    return _account!;
  }

  /// Returns if an account is connected
  bool hasConnectedAccount() {
    return _account != null;
  }

  /// Tries to log in to an account
  Future<bool> tryLogin(String email, String password) async {
    _account = await AccountService.tryLogin(email, password);
    return hasConnectedAccount();
  }

  /// Tries to sign up with a new account
  Future<bool> trySignUp(String email, String password) async {
    _account = await AccountService.trySignUp(email, password);
    return hasConnectedAccount();
  }

  /// Logs out a connected account
  Future<bool> logout() async {
    bool loggedOut = await AccountService.logout();
    if (loggedOut) {
      _account = null;
    }
    return !hasConnectedAccount();
  }
}
