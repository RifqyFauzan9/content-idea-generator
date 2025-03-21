import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:schedule_generator/network/gemini_service.dart';
import 'package:schedule_generator/services/shared_preferences_service.dart';
import 'package:schedule_generator/size_config.dart';
import 'package:schedule_generator/theme/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  List<Map<String, dynamic>> shortForm = [];
  List<Map<String, dynamic>> longForm = [];
  List<Map<String, dynamic>> interactive = [];
  List<String> suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Disini ada generator yow!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Masukkan Topic-nya dulu yow!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextField(controller: _topicController),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _generateSchedule(_topicController.text),
                icon: Icon(Icons.bolt, size: 24),
                label: const Text('Generate Mas Yow!'),
              ),
              const SizedBox(height: 4),
              if (!isLoading &&
                  errorMessage.isEmpty &&
                  (shortForm.isEmpty ||
                      longForm.isEmpty ||
                      interactive.isEmpty))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.12),
                    Icon(
                      Icons.mood_bad_outlined,
                      size: getPropScreenWidth(150),
                      color: kPrimaryColor,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Text(
                      'Ayo di-generate yow!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              if (isLoading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.13),
                    LoadingAnimationWidget.threeArchedCircle(
                      color: kPrimaryColor,
                      size: getPropScreenWidth(120),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    Text(
                      'Sebentar yow!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              if (!isLoading &&
                  errorMessage.isEmpty &&
                  (shortForm.isNotEmpty ||
                      longForm.isNotEmpty ||
                      interactive.isNotEmpty))
                Column(
                  children: [
                    const Divider(thickness: 2, color: kPrimaryColor),
                    // Morning
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Versi Pendek',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            if (shortForm.isEmpty)
                              Text(
                                'No Tasks',
                                style: GoogleFonts.poppins(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ...shortForm.take(2).map(
                                  (task) => ListTile(
                                    title: Text(
                                      task['title'] ?? 'Task',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task['description'],
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Afternoon
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Versi Panjang',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            if (longForm.isEmpty)
                              Text(
                                'No Tasks',
                                style: GoogleFonts.poppins(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ...longForm.take(2).map(
                                  (task) => ListTile(
                                    title: Text(
                                      task['title'] ?? 'Task',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task['description'],
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Evening
                    Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interaktif',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            if (interactive.isEmpty)
                              Text(
                                'No Tasks',
                                style: GoogleFonts.poppins(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ...interactive.take(2).map(
                                  (task) => ListTile(
                                    title: Text(
                                      task['title'] ?? 'Task',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task['description'],
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saran',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: getPropScreenWidth(20),
                            color: Theme.of(context).colorScheme.primary
                          ),
                        ),
                        if (suggestions.isEmpty)
                          Text(
                            'No Suggestions',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          ),
                        ...suggestions.take(3).map(
                              (suggestion) => ListTile(
                            leading: Icon(
                              Icons.lightbulb,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                            title: Text(
                              suggestion,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: getPropScreenWidth(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateSchedule(String topic) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      _topicController.clear();
    });

    try {
      final result = await GeminiService.generateSchedule(topic);

      if (topic.isEmpty) {
        setState(() {
          isLoading = false;
        });
        _showSnackbar(
          'Masukkan topic-nya dulu yow!',
          Theme.of(context).colorScheme.error,
        );
        return;
      }

      if (result.containsKey('error')) {
        setState(() {
          isLoading = false;
        });
        _showSnackbar(
          result['error'],
          Theme.of(context).colorScheme.error,
        );
        return;
      }

      // Pastikan respons tidak null
      if (result['short_form'] == null ||
          result['long_form'] == null ||
          result['interactive'] == null ||
          result['suggestions'] == null) {
        setState(() {
          isLoading = false;
        });
        _showSnackbar(
          'Invalid response format from Gemini.',
          Theme.of(context).colorScheme.error,
        );
        return;
      }

      await HistoryService.saveHistory({
        'title': topic,
        'date': DateTime.now().toString(),
      });
      _showSnackbar(
        'Berhasil di-generate yow!',
        Color(0xFF212121),
      );
      // Update state dengan data yang diterima
      setState(() {
        shortForm = List<Map<String, dynamic>>.from(result['short_form']);
        longForm = List<Map<String, dynamic>>.from(result['long_form']);
        interactive = List<Map<String, dynamic>>.from(result['interactive']);
        suggestions = List<String>.from(result['suggestions']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackbar(
        'Failed to generate Idea: $e',
        Theme.of(context).colorScheme.error,
      );
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _topicController.dispose();
  }
}
