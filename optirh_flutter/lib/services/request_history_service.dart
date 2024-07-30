import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';

class RequestHistoryService {
  Future<List<Map<String, dynamic>>> fetchRequestHistory() async {
    // Récupérez les en-têtes avec le token
    Map<String, String> headers = await APIService.header;

    final response = await http.get(
      Uri.parse('${APIService.apiURL}requesthistory/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load request history');
    }
  }
}
