import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../config.dart';

/// Repository backed by shared_preferences (offline-first).
class ItemRepo extends ChangeNotifier {
  static const _key = 'items_v1';
  final List<Item> _items = [];
  int _nextId = 1;
  bool _loaded = false;

  bool get loaded => _loaded;
  List<Item> get items => List.unmodifiable(_items);
  List<Item> get pending => _items.where((e) => !e.flag).toList();
  List<Item> get flagged => _items.where((e) => e.flag).toList();
  double get total => _items.fold(0.0, (a, e) => a + e.value);
  double get flagTotal =>
      _items.where((e) => e.flag).fold(0.0, (a, e) => a + e.value);
  double get pendingTotal =>
      _items.where((e) => !e.flag).fold(0.0, (a, e) => a + e.value);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
      _items
        ..clear()
        ..addAll(list.map(Item.fromJson));
      _nextId = _items.fold(0, (m, e) => e.id > m ? e.id : m) + 1;
    } else {
      _seed();
      await _persist();
    }
    _loaded = true;
    notifyListeners();
  }

  void _seed() {
    for (final s in AppConfig.seed) {
      _items.add(Item(
        id: _nextId++,
        title: s[0] as String,
        detail: s[1] as String,
        value: (s[2] as num).toDouble(),
        flag: s[3] as bool,
        category: s[4] as String,
      ));
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(_items.map((e) => e.toJson()).toList()));
  }

  Future<void> add(String title, String detail, double value, bool flag,
      String category) async {
    _items.add(Item(
      id: _nextId++,
      title: title,
      detail: detail,
      value: value,
      flag: flag,
      category: category,
    ));
    notifyListeners();
    await _persist();
  }

  Future<void> update(int id, String title, String detail, double value,
      bool flag, String category) async {
    final it = _items.firstWhere((e) => e.id == id);
    it.title = title;
    it.detail = detail;
    it.value = value;
    it.flag = flag;
    it.category = category;
    notifyListeners();
    await _persist();
  }

  Future<void> remove(int id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> toggle(int id) async {
    final it = _items.firstWhere((e) => e.id == id);
    it.flag = !it.flag;
    notifyListeners();
    await _persist();
  }

  Map<String, double> get byCategory {
    final Map<String, double> m = {};
    for (final it in _items) {
      final k = it.category.isEmpty ? 'Other' : it.category;
      m[k] = (m[k] ?? 0) + (AppConfig.usesValue ? it.value : 1.0);
    }
    return m;
  }
}
