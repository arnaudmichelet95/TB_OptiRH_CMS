import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/globs.dart';

/// SimpleSnackBar class is used to define quickly usable methods to display simple SnackBars
class SimpleSnackBar {
  /// Shows a SnackBar during a fixed duration of 3 seconds containing the message provided. Closes on click on the "OK" button.
  static void showSnackBar(BuildContext context, String message) {
    final sb = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: Globs.appSnackBarDurationInSec),
    );
    ScaffoldMessenger.of(context).showSnackBar(sb);
  }
}