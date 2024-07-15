import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/helpers/account_manager.dart';
import 'package:optirh_flutter/pages/login_page.dart';
import 'package:optirh_flutter/widgets/simple_snack_bar.dart';
import 'package:optirh_flutter/widgets/button_widget.dart';
import 'package:optirh_flutter/services/simplify_translate_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleLogout() async {
    AccountManager manager = AccountManager.getInstance();
    AppLocalization loc = AppLocalization.of(context);
    bool ok = await manager.logout();
    if (ok) {
      _showLogoutSnackbar(loc.getTranslation("LOGOUT_SUCCESS_MSG"), true);
    } else {
      _showLogoutSnackbar(loc.getTranslation("LOGOUT_ERR_MSG"), false);
    }
  }

  /// Shows the logout snackbar
  void _showLogoutSnackbar(String message, bool deleteRoutes) {
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

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  String _vulgarization = '';
  String _termExplanation = '';
  String _errorMessage = '';

  final SimplifyTranslateService _service = SimplifyTranslateService();

  Future<void> _simplifyAndTranslate() async {
    if (_textController.text.isEmpty || _languageController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in both fields';
      });
      return;
    }
    setState(() {
      _errorMessage = '';
    });

    try {
      final result = await _service.simplifyAndTranslateText(
        _textController.text,
        _languageController.text,
      );
      setState(() {
        _vulgarization = result['vulgarization'] ?? 'No vulgarization available';
        _termExplanation = result['term_explanation'] ?? 'No term explanation available';
      });
    } catch (e) {
      setState(() {
        _vulgarization = 'Error: $e';
        _termExplanation = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.getTranslation("TITLE_HOMEPAGE")),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ButtonWidget(
              text: loc.getTranslation("LOGOUT"),
              action: _handleLogout,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_TO_SUBMIT"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_LANGUAGE"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _simplifyAndTranslate,
              icon: Icon(Icons.translate),
              label: Text(loc.getTranslation("TEXT_SUBMIT")),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.getTranslation("VULGARIZATION"),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 8.0),
                              Text(_vulgarization),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.getTranslation("TERM_EXPLANATION"),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 8.0),
                              Text(_termExplanation),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
