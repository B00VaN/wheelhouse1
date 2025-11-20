import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/voyage.dart';

class StorageService {
  static const _voyagesKey = 'vh_voyages';

  static Future<List<Voyage>> loadVoyages() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_voyagesKey) ?? <String>[];
    try {
      return list.map((s) => Voyage.fromJsonString(s)).toList();
    } catch (e) {
      debugPrint('Failed to parse voyages: $e');
      return [];
    }
  }

  static Future<void> saveVoyages(List<Voyage> voyages) async {
    final prefs = await SharedPreferences.getInstance();
    final list = voyages.map((v) => v.toJsonString()).toList();
    await prefs.setStringList(_voyagesKey, list);
  }

  static Future<void> addVoyage(Voyage v) async {
    final current = await loadVoyages();
    current.insert(0, v); // newest first
    await saveVoyages(current);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_voyagesKey);
  }
}
