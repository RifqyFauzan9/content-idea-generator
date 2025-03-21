import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyAFaBbI8ZaMyAXv9quvUz7Tj_tr6np_5gU';

  static Future<Map<String, dynamic>> generateSchedule(String topic) async {
    final prompt = _buildPrompt(topic);

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    final chat = model.startChat(history: [
      Content.multi([
        TextPart(
            'Anda adalah AI yang bertugas sebagai penghasil ide konten berdasarkan topik yang diberikan oleh pengguna. Pastikan setiap topik yang diberikan memiliki minimal 3 ide konten yang kreatif dan menarik. Struktur output harus dalam format JSON dengan tiga bagian utama: "short_form", "long_form", dan "interactive".  \n\nSetiap bagian harus berisi array ide konten dengan bidang "title" (judul) dan "description" (deskripsi singkat).  \n\nSelalu sertakan bagian "suggestions" di akhir, yang berisi rekomendasi tambahan terkait pengembangan ide konten agar lebih menarik. Gunakan lebih banyak emotikon untuk menambah daya tarik pada ide yang dihasilkan. Jangan sertakan teks tambahan di luar struktur JSON.  \n'),
      ]),
      Content.model([
        TextPart(
            '```json\n{\n  "short_form": [\n    {\n      "title": "Rahasia Sukses Bisnis Online dalam 60 Detik 🚀",\n      "description": "Video singkat berisi tips praktis dan langsung bisa diterapkan untuk meningkatkan penjualan online. Gunakan musik yang upbeat dan visual menarik! ✨"\n    }\n  ]\n}\n```'),
      ]),
    ]);

    final message = topic; // Use the topic provided by the user
    final content = Content.text(message);

    try {
      final response = await chat.sendMessage(content);
      final responseText =
          (response.candidates.first.content.parts.first as TextPart).text;

      debugPrint("Raw Response: $responseText"); // Log the raw response

      if (responseText.isEmpty) {
        return {'error': 'Failed to generate idea.'};
      }

      // Extract JSON from the response
      final jsonPattern = RegExp(r'\{.*\}', dotAll: true);
      final match = jsonPattern.firstMatch(responseText);

      if (match == null) {
        return {'error': 'No valid JSON found in the response.'};
      }

      final jsonString = match.group(0)!;
      debugPrint("Extracted JSON: $jsonString"); // Log the extracted JSON

      // Parse the JSON
      return json.decode(jsonString);
    } catch (e) {
      debugPrint("Error parsing JSON: $e"); // Log the error
      return {'error': 'Failed to parse response: $e'};
    }
  }

  static String _buildPrompt(String topic) {
    return 'Buatkan ide konten yang kreatif dan menarik dari topic berikut: \n$topic\nBuatkan ide konten yang menarik dan kreatif dengan efisien dan berikan output dalam bentuk JSON.';
  }
}
