import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/pages/vulgarization_page.dart';
import 'package:optirh_flutter/pages/summarize_page.dart';
import 'package:optirh_flutter/helpers/account_manager.dart';
import 'package:optirh_flutter/pages/login_page.dart';
import 'package:optirh_flutter/widgets/simple_snack_bar.dart';
import 'package:optirh_flutter/widgets/button_widget.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  void _handleLogout(BuildContext context) async {
    AccountManager manager = AccountManager.getInstance();
    AppLocalization loc = AppLocalization.of(context);
    bool ok = await manager.logout();
    if (ok) {
      _showLogoutSnackbar(context, loc.getTranslation("LOGOUT_SUCCESS_MSG"), true);
    } else {
      _showLogoutSnackbar(context, loc.getTranslation("LOGOUT_ERR_MSG"), false);
    }
  }

  void _showLogoutSnackbar(BuildContext context, String message, bool deleteRoutes) {
    SimpleSnackBar.showSnackBar(context, message);
    if (deleteRoutes) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Demo app Optirh'),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.chat), text: loc.getTranslation("TAB_VULGA")),
              Tab(icon: const Icon(Icons.summarize), text: loc.getTranslation("TAB_SUM")),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ButtonWidget(
                text: loc.getTranslation("LOGOUT"),
                action: () => _handleLogout(context),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            VulgarizationPage(),
            SummarizePage(),
          ],
        ),
      ),
    );
  }
}
