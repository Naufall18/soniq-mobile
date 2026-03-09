import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Soniq';
  static const Color seedColor = Color(0xFF673AB7);
  static const String noun = 'Song';

  static const bool usesValue = false;
  static const bool usesFlag = true;
  static const bool tab2Flagged = true;

  static const String valueLabel = 'Amount';
  static const String flagLabel = 'Favorite';
  static const String detailLabel = 'Artist';
  static const String categoryLabel = 'Genre';

  static const String tab1 = 'Library';
  static const String tab2 = 'Favorites';
  static const String tab3 = 'Insights';
  static const IconData icon1 = Icons.library_music;
  static const IconData icon2 = Icons.favorite;
  static const IconData icon3 = Icons.insights;

  // seed rows: [title, detail, value, flag, category]
  static const List<List<Object>> seed = [
    ['Bohemian Rhapsody', 'Queen', 0, true, 'Rock'],
    ['Blinding Lights', 'The Weeknd', 0, false, 'Pop'],
    ['Yellow', 'Coldplay', 0, true, 'Alternative'],
    ['Levitating', 'Dua Lipa', 0, false, 'Pop'],
    ['Numb', 'Linkin Park', 0, true, 'Rock'],
    ['Weightless', 'Marconi Union', 0, false, 'Ambient'],
  ];
}
