import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class SummarizePfService {
  Future<List<Map<String, dynamic>>?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
      allowMultiple: true,
    );

    if (result != null) {
      return result.files.map((file) => {
        'fileName': file.name,
        'fileBytes': base64Encode(file.bytes!), // Convertir les bytes en base64
      }).toList();
    }
    return null;
  }

  Future<Map<String, String>> summarizeFiles(List<Map<String, dynamic>> filesData, String language) async {
    Map<String, String> headers = await APIService.header;
    headers['Content-Type'] = 'application/json'; // Assurez-vous que le type de contenu est JSON

    final requestPayload = {
      'language': language,
      'files': filesData, // Inclure les fichiers dans le payload
    };

    final response = await http.post(
      Uri.parse('${APIService.apiURL}summarizepf/'),
      headers: headers,
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      return {
        'personal_data': responseJson['summary']['personal_data'] ?? '',
        'case': responseJson['summary']['case'] ?? '',
        'social_network': responseJson['summary']['social_network'] ?? '',
        'general_info': responseJson['summary']['general_info'] ?? '',
        'allergies': responseJson['summary']['allergies'] ?? '',
        'medic_history': responseJson['summary']['medic_history'] ?? '',
        'medication': responseJson['summary']['medication'] ?? '',
      };
    } else {
      throw Exception('Failed to summarize the files');
    }
  }
}
