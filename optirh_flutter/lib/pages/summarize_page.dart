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
  String _personalData = '';
  String _case = '';
  String _socialNetwork = '';
  String _generalInfo = '';
  String _allergies = '';
  String _medicHistory = '';
  String _medication = '';
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
      final result = await _service.summarizeFiles(_filesData, _languageController.text);
      setState(() {
        _personalData = result['personal_data'] ?? 'No personal data available';
        _case = result['case'] ?? 'No case information available';
        _socialNetwork = result['social_network'] ?? 'No social network information available';
        _generalInfo = result['general_info'] ?? 'No general information available';
        _allergies = result['allergies'] ?? 'No allergies information available';
        _medicHistory = result['medic_history'] ?? 'No medical history available';
        _medication = result['medication'] ?? 'No medication information available';
      });
    } catch (e) {
      setState(() {
        _personalData = 'Error: $e';
        _case = 'Error: $e';
        _socialNetwork = 'Error: $e';
        _generalInfo = 'Error: $e';
        _allergies = 'Error: $e';
        _medicHistory = 'Error: $e';
        _medication = 'Error: $e';
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
              child: Text(loc.getTranslation("PICK_XML")),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(loc.getTranslation('PERSONAL_DATA'), _personalData),
                    _buildSectionCard(loc.getTranslation('CASE'), _case),
                    _buildSectionCard(loc.getTranslation('SOCIAL_NETWORK'), _socialNetwork),
                    _buildSectionCard(loc.getTranslation('GENERAL_INFO'), _generalInfo),
                    _buildSectionCard(loc.getTranslation('ALLERGIES'), _allergies),
                    _buildSectionCard(loc.getTranslation('MEDIC_HISTORY'), _medicHistory),
                    _buildSectionCard(loc.getTranslation('MEDICATION'), _medication),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String content) {
    return Container(
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
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8.0),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}
