import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';

class SimplifyTranslateService {
  Future<Map<String, String>> simplifyAndTranslateText(String text, String language) async {
    // Récupérez les en-têtes avec le token
    Map<String, String> headers = await APIService.header;

    final response = await http.post(
      Uri.parse('${APIService.apiURL}simplifytranslate/'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'text': text,
        'language': language,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return {
        'vulgarization': responseJson['vulgarization'],
        'term_explanation': responseJson['term_explanation'],
      };
    } else {
      throw Exception('Failed to simplify and translate text');
    }
  }
}
