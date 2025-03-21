import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../size_config.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;

  const DetailScreen({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Konversi data ke tipe yang benar
    List<Map<String, dynamic>> shortForm = [];
    List<Map<String, dynamic>> longForm = [];
    List<Map<String, dynamic>> interactive = [];
    List<String> suggestions = [];

    try {
      if (data['short_form'] != null) {
        shortForm =
            (data['short_form'] as List<dynamic>).cast<Map<String, dynamic>>();
      }
      if (data['long_form'] != null) {
        longForm =
            (data['long_form'] as List<dynamic>).cast<Map<String, dynamic>>();
      }
      if (data['interactive'] != null) {
        interactive =
            (data['interactive'] as List<dynamic>).cast<Map<String, dynamic>>();
      }
      if (data['suggestions'] != null) {
        suggestions = (data['suggestions'] as List<dynamic>).cast<String>();
      }
    } catch (e) {
      debugPrint("Error converting data: $e");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
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
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ...shortForm.take(2).map(
                              (task) => ListTile(
                                title: Text(
                                  task['title'] ?? 'Task',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ...longForm.take(2).map(
                              (task) => ListTile(
                                title: Text(
                                  task['title'] ?? 'Task',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ...interactive.take(2).map(
                              (task) => ListTile(
                                title: Text(
                                  task['title'] ?? 'Task',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                          color: Theme.of(context).colorScheme.primary),
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
                              color: Theme.of(context).colorScheme.primary,
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
          ),
        ),
      ),
    );
  }
}
