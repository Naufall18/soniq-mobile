import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/repo.dart';

class CategoryChart extends StatelessWidget {
  final ItemRepo repo;
  const CategoryChart({super.key, required this.repo});

  static const List<Color> _palette = [
    Color(0xFF7C4DFF),
    Color(0xFF00BCD4),
    Color(0xFFFF7043),
    Color(0xFF66BB6A),
    Color(0xFFFFCA28),
    Color(0xFFEC407A),
    Color(0xFF42A5F5),
    Color(0xFFAB47BC),
  ];

  @override
  Widget build(BuildContext context) {
    final totals = repo.byCategory;
    if (totals.isEmpty) return const SizedBox.shrink();
    final entries = totals.entries.toList();
    final grand = entries.fold<double>(0, (a, e) => a + e.value);

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final double pct = grand == 0 ? 0 : e.value / grand * 100;
      sections.add(PieChartSectionData(
        value: e.value,
        title: '${pct.toStringAsFixed(0)}%',
        color: _palette[i % _palette.length],
        radius: 68,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Column(
      children: [
        SizedBox(
          height: 210,
          child: PieChart(
            PieChartData(sections: sections, centerSpaceRadius: 34),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < entries.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _palette[i % _palette.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${entries[i].key} (${entries[i].value.toStringAsFixed(0)})'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
