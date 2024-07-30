import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/globs.dart';

/// LabelledTextFieldWidget class, creates a text field linked to a label
class LabelledTextFieldWidget extends StatefulWidget {
  /// Creates a new LabelledTextFieldWidget
  const LabelledTextFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.isPassword,
    this.validateInput,
    this.required = false,
    int? maxLines,
  }) : maxLines = isPassword ? 1 : maxLines ?? 1;

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final Function(BuildContext context, String value)? validateInput;
  final bool required;
  final int maxLines; // Change to non-nullable int

  @override
  State<LabelledTextFieldWidget> createState() =>
      _LabelledTextFieldWidgetState();
}

/// LabelledTextFieldWidget state class
class _LabelledTextFieldWidgetState extends State<LabelledTextFieldWidget> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(Globs.appDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.required
                  ? "${widget.label} ${loc.getTranslation("REQUIRED")}"
                  : widget.label,
              style: theme.textTheme.displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                  ),
                  obscureText: widget.isPassword,
                  onChanged: (value) {
                    setState(() {
                      _errorText = widget.validateInput != null
                          ? widget.validateInput!(context, value)
                          : null;
                    });
                  },
                  maxLines: widget.maxLines, // Use the corrected maxLines
                ),
                if (_errorText != null)
                  Container(
                    padding:
                        const EdgeInsets.only(top: Globs.appDefaultPadding),
                    child: Text(
                      _errorText!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: theme.textTheme.displaySmall!.fontSize,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
