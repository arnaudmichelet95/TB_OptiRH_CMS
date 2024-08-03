import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';

class SummaryHistoryService {
  Future<List<Map<String, dynamic>>> fetchSummaryHistory() async {
    Map<String, String> headers = await APIService.header;

    final response = await http.get(
      Uri.parse('${APIService.apiURL}summaryhistory/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load summary history');
    }
  }
}