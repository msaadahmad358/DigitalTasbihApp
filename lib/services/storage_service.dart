import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/tasbih_item.dart';

class StorageService {
  static const String _tasbihsKey = 'tasbihs';

  static Future<void> saveTasbihs(List<TasbihItem> tasbihs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _tasbihsKey,
      jsonEncode(tasbihs.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<TasbihItem>> loadTasbihs(
    List<TasbihItem> defaultTasbihs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_tasbihsKey);
    if (saved != null) {
      List<dynamic> decoded = jsonDecode(saved);
      return decoded.map((e) => TasbihItem.fromJson(e)).toList();
    }
    return List.from(defaultTasbihs);
  }
}
