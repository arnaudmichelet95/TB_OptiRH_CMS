import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> simplifyAndTranslateText(String text, String language) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/simplify-translate/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'text': text,
      'language': language,
    }),
  );

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body);
    return responseJson['response'];
  } else {
    throw Exception('Failed to simplify and translate text');
  }
}