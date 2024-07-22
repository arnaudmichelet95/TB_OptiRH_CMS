import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/services/simplify_translate_service.dart';

class VulgarizationPage extends StatefulWidget {
  const VulgarizationPage({super.key});

  @override
  State<VulgarizationPage> createState() => _VulgarizationPageState();
}

class _VulgarizationPageState extends State<VulgarizationPage> {
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
        title: Text(loc.getTranslation("TITLE_VULGARIZATION")),
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
