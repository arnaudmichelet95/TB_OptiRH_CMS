import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  String _result = '';

  Future<void> _simplifyAndTranslate() async {
    try {
      final result = await simplifyAndTranslateText(
        _textController.text,
        _languageController.text,
      );
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.getTranslation("TITLE_HOMEPAGE")),
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
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_LANGUAGE"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _simplifyAndTranslate,
              child: Text(loc.getTranslation("TEXT_SUBMIT")),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> simplifyAndTranslateText(String text, String language) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/optirh_app/api/simplifytranslate/'),  // Ensure this URL is correct
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'text': text,
      'language': language,
    }),
  );

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    return responseJson['response'];
  } else {
    throw Exception('Failed to simplify and translate text');
  }
}
