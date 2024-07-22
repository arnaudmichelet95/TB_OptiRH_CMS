import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class SummarizePfService {
  Future<String> summarizeFile(String fileName, List<int> fileBytes, String language) async {
    // Récupérez les en-têtes avec le token
    Map<String, String> headers = await APIService.header;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${APIService.apiURL}summarizepf/'),
    );

    request.headers.addAll(headers);
    request.fields['language'] = language;
    request.files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['summary'];
    } else {
      var responseData = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseData');
      throw Exception('Failed to summarize the file');
    }
  }

  Future<Map<String, dynamic>?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx'],
      );

      if (result != null && result.files.single.bytes != null) {
        String fileName = result.files.single.name;
        List<int> fileBytes = result.files.single.bytes!;
        print('Selected file name: $fileName');
        return {'fileName': fileName, 'fileBytes': fileBytes};
      } else {
        print('No file selected.');
        return null;
      }
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }
}
