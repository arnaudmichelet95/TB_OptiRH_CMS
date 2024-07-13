import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/globs.dart';

/// RectangularContainerWidget is a rectangular container for custom pages
class RectangularContainerWidget extends StatelessWidget {
  /// Creates a new RectangularContainerWidget
  const RectangularContainerWidget({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * Globs.rectContWidthFactor,
          height:
              MediaQuery.of(context).size.height * Globs.rectContHeightFactor,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: Globs.appDefaultBorderWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(Globs.appDefaultPadding),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Globs.appDefaultPadding),
                  child: SingleChildScrollView(
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
