import 'package:flutter/material.dart';
import 'package:optirh_flutter/helpers/app_localization.dart';
import 'package:optirh_flutter/services/simplify_translate_service.dart';
import 'package:optirh_flutter/services/request_history_service.dart';

class VulgarizationPage extends StatefulWidget {
  const VulgarizationPage({super.key});

  @override
  State<VulgarizationPage> createState() => _VulgarizationPageState();
}

class _VulgarizationPageState extends State<VulgarizationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  String _vulgarization = '';
  String _termExplanation = '';
  String _errorMessage = '';

  final SimplifyTranslateService _service = SimplifyTranslateService();
  final RequestHistoryService _historyService = RequestHistoryService();

  List<Map<String, dynamic>> _requestHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchRequestHistory();
  }

  Future<void> _fetchRequestHistory() async {
    try {
      List<Map<String, dynamic>> history = await _historyService.fetchRequestHistory();
      setState(() {
        _requestHistory = history;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load request history: $e';
      });
    }
  }

  Future<void> _simplifyAndTranslate() async {
    if (_textController.text.isEmpty || _languageController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in both fields';
      });
      return;
    }
    setState(() {
      _errorMessage = '';
    });

    try {
      final result = await _service.simplifyAndTranslateText(
        _textController.text,
        _languageController.text,
      );
      setState(() {
        _vulgarization = result['vulgarization'] ?? 'No vulgarization available';
        _termExplanation = result['term_explanation'] ?? 'No term explanation available';
      });
    } catch (e) {
      setState(() {
        _vulgarization = 'Error: $e';
        _termExplanation = 'Error: $e';
      });
    }
  }

  void _loadRequestDetails(Map<String, dynamic> request) {
    setState(() {
      _textController.text = request['original_text'] ?? '';
      _vulgarization = request['vulgarization'] ?? '';
      _termExplanation = request['term_explanation'] ?? '';
    });
  }

  void _resetFields() {
    setState(() {
      _textController.clear();
      _languageController.clear();
      _vulgarization = '';
      _termExplanation = '';
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalization loc = AppLocalization.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(loc.getTranslation("TITLE_VULGARIZATION")),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          tooltip: loc.getTranslation("OPEN_HISTORY_DRAWER"),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFields,
            tooltip: loc.getTranslation("NEW"),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 60.0, // Adjust the height as needed
              color: Theme.of(context).primaryColor,
              alignment: Alignment.center,
              child: Text(
                loc.getTranslation("HISTORY"),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ..._requestHistory.map((request) {
              return ListTile(
                title: Text(request['request_name']),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _loadRequestDetails(request);
                },
              );
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_TO_SUBMIT"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.text_fields),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: loc.getTranslation("TEXT_LANGUAGE"),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.language),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _simplifyAndTranslate,
              icon: const Icon(Icons.translate),
              label: Text(loc.getTranslation("TEXT_SUBMIT")),
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
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
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
                                loc.getTranslation("VULGARIZATION"),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 8.0),
                              Text(_vulgarization),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                                loc.getTranslation("TERM_EXPLANATION"),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 8.0),
                              Text(_termExplanation),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}