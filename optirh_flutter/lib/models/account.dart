import 'package:optirh_flutter/models/base_model.dart';

/// Account class, model to store client account
class Account extends BaseModel {
  final String email;

    Account(
    super.id,
    this.email,
  );

  /// Creates an account from json data
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      json['id'] as int,
      json['email'] as String,
    );
  }
}
