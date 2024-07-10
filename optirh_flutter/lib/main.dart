import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/globs.dart';
import 'package:provider/provider.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/pages/home_page.dart';

void main() {
  runApp(const AppOptiRH());
}

class AppOptiRH extends StatelessWidget {
  const AppOptiRH({super.key});

  static const primary = Color(0xFFBCC1EC); //card background color
  static const secondary = Color(0xFF676664);
  static const tertiary = Color(0xFF1B8989);
  static const error = Color(0xFF942A3D); // error color
  static const surface = Color(0xFFEEEEEE); // backgroud color
  static const onSurface = Color(0xFF000000); // text color on the background
  static const shadow = Color(0xFF999999);
  static const onPrimaryContainer = Color(0xFFFFFFF3); // button text color
  static const secondaryContainer = Color(0xFFD9D9D9); // text field color

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleNotifier()),
      ],
      builder: (context, child) {
        final appLocaleProvider = Provider.of<LocaleNotifier>(context);
        return MaterialApp(
          locale: appLocaleProvider.locale,
          localizationsDelegates: AppLocalization.localizationsDelegates,
          supportedLocales: AppLocalization.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var loc in supportedLocales) {
                if (loc.languageCode == locale.languageCode) {
                  return locale;
                }
              }
            }
            return supportedLocales.first;
          },
          title: AppConfiguration.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primary,
              primary: primary,
              error: error,
              secondary: secondary,
              surface: surface,
              tertiary: tertiary,
              onSurface: onSurface,
              shadow: shadow,
              onPrimaryContainer: onPrimaryContainer,
              secondaryContainer: secondaryContainer
            ),
             textTheme: const TextTheme(
            displaySmall: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 16,
            ),
            displayMedium: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 20,
            ),
            displayLarge: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 24,
            ),
            titleSmall: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 16,
            ),
            titleMedium: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 26,
            ),
            titleLarge: TextStyle(
              fontFamily: Globs.appFontFamily,
              fontSize: 30,
            )),
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}