import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/services/summarize_pf_service.dart';

class SummarizePage extends StatefulWidget {
  const SummarizePage({super.key});

  @override
  State<SummarizePage> createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  final List<Map<String, dynamic>> _filesData = [];
  String _summary = '';
  String _errorMessage = '';
  final TextEditingController _languageController = TextEditingController();

  final SummarizePfService _service = SummarizePfService();

  Future<void> _pickFiles() async {
    var filesData = await _service.pickFiles();
    if (filesData != null) {
      setState(() {
        _filesData.addAll(filesData);
        _errorMessage = ''; // Clear any previous errors
      });
    } else {
      setState(() {
        _errorMessage = 'No files selected or error picking files';
      });
    }
  }

  Future<void> _summarizeFiles() async {
    if (_filesData.isEmpty || _languageController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please select files and fill in the language field';
      });
      return;
    }
    setState(() {
      _errorMessage = '';
    });

    try {
      String summary = await _service.summarizeFiles(_filesData, _languageController.text);
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
              onPressed: _pickFiles,
              child: Text(loc.getTranslation("PICK_DOCX")),
            ),
            const SizedBox(height: 20),
            _filesData.isNotEmpty
                ? Column(
                    children: _filesData.map((file) => Text(file['fileName'])).toList(),
                  )
                : Text(loc.getTranslation("NO_FILE_SELECTED")),
            const SizedBox(height: 20),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_LANGUAGE"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _summarizeFiles,
              icon: const Icon(Icons.summarize),
              label: Text(loc.getTranslation('SUM_FILE')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.getTranslation('SUMMED_FILE'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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