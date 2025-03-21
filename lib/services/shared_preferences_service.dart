import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _historyKey = 'history_list';

  /// Simpan history ke SharedPreferences
  static Future<void> saveHistory(Map<String, dynamic> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList(_historyKey) ?? [];

      // Tambahkan history baru ke list
      historyList.add(jsonEncode(history));

      // Simpan kembali ke SharedPreferences
      await prefs.setStringList(_historyKey, historyList);
    } catch (e) {
      debugPrint("Error saving history: $e");
    }
  }

  /// Ambil semua history dari SharedPreferences
  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList(_historyKey) ?? [];

      return historyList
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('error loading history: $e');
      return [];
    }
  }

  /// Hapus satu history berdasarkan index
  static Future<void> deleteHistory(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> historyList = prefs.getStringList(_historyKey) ?? [];

      if (index < historyList.length) {
        historyList.removeAt(index);
        await prefs.setStringList(_historyKey, historyList);
      }
    } catch (e) {
      debugPrint('error deleting history: $e');
    }
  }

  /// Hapus semua history
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      debugPrint('error clearing history: $e');
    }
  }
}
