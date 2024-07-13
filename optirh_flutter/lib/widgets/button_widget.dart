import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/globs.dart';

/// ButtonWidget class, defines the buttons used in the application
class ButtonWidget extends StatelessWidget {
  /// Creates a new ButtonWidget
  const ButtonWidget({
    super.key,
    required this.text,
    required this.action,
    this.enabled = true,
  });

  final String text;
  final Function() action;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ElevatedButton(
      onPressed: enabled ? action : null,
      style: ButtonStyle(
        backgroundColor: enabled
            ? WidgetStateProperty.all(Colors
                .blueAccent) // Utilise une couleur pastel pour le fond du bouton
            : WidgetStateProperty.all(Colors
                .blueGrey), // Utilise une couleur pastel plus claire pour le fond du bouton désactivé
        textStyle: WidgetStateProperty.all(
          theme.textTheme.bodyMedium,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Globs.btnVertPadding,
          horizontal: Globs.btnHorzPadding,
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white), // Choisir la couleur du texte ici
        ),
      ),
    );
  }
}
