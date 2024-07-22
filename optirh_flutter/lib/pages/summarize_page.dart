import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/services/summarize_pf_service.dart';

class SummarizePage extends StatefulWidget {
  const SummarizePage({super.key});

  @override
  State<SummarizePage> createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  String? _fileName;
  List<int>? _fileBytes;
  String _summary = '';
  String _errorMessage = '';
  final TextEditingController _languageController = TextEditingController();

  final SummarizePfService _service = SummarizePfService();

  Future<void> _pickFile() async {
    var fileData = await _service.pickFile();
    if (fileData != null) {
      setState(() {
        _fileName = fileData['fileName'];
        _fileBytes = fileData['fileBytes'];
        _errorMessage = ''; // Clear any previous errors
      });
    } else {
      setState(() {
        _errorMessage = 'No file selected or error picking file';
      });
    }
  }

  Future<void> _summarizeFile() async {
    if (_fileName == null || _fileBytes == null || _languageController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please select a file and fill in the language field';
      });
      return;
    }
    setState(() {
      _errorMessage = '';
    });

    try {
      String summary = await _service.summarizeFile(_fileName!, _fileBytes!, _languageController.text);
      setState(() {
        _summary = summary;
      });
    } catch (e) {
      setState(() {
        _summary = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.getTranslation("TITLE_SUM_PAGE")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(loc.getTranslation("PICK_DOCX")),
            ),
            const SizedBox(height: 20),
            Text(_fileName ?? 'No file selected'),
            const SizedBox(height: 20),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_LANGUAGE"),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _summarizeFile,
              icon: Icon(Icons.summarize),
              label: Text(loc.getTranslation('SUM_FILE')),
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
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
                            loc.getTranslation('SUMMED_FILE'),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8.0),
                          Text(_summary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
