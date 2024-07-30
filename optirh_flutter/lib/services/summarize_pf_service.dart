import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optirh_flutter/services/api_service.dart';
import 'package:file_picker/file_picker.dart';

class SummarizePfService {
  Future<List<Map<String, dynamic>>?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
      allowMultiple: true,
    );

    if (result != null) {
      return result.files.map((file) => {
        'fileName': file.name,
        'fileBytes': file.bytes,
      }).toList();
    }
    return null;
  }

  Future<String> summarizeFiles(List<Map<String, dynamic>> filesData, String language) async {
    Map<String, String> headers = await APIService.header;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIService.apiURL}summarizepf/'),
    );

    request.headers.addAll(headers);
    request.fields['language'] = language;

    for (var fileData in filesData) {
        request.files.add(
            http.MultipartFile.fromBytes(
                'files',
                fileData['fileBytes'],
                filename: fileData['fileName'],
            ),
        );
    }

    // Log the request data
    print("Request Files Data: $filesData");

    var response = await request.send();

    if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        return jsonResponse['summary'];
    } else {
        throw Exception('Failed to summarize the files');
    }
  }
}
