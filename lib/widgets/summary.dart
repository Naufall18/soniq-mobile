import 'package:flutter/material.dart';
import '../data/repo.dart';
import '../config.dart';
import 'category_chart.dart';

class SummaryScreen extends StatelessWidget {
  final ItemRepo repo;
  const SummaryScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) {
        if (!repo.loaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _tile(context, 'Total ${AppConfig.noun}s', repo.items.length.toString()),
            if (AppConfig.usesFlag)
              _tile(context, AppConfig.flagLabel, repo.flagged.length.toString()),
            if (AppConfig.usesValue) ...[
              _tile(context, 'Total ${AppConfig.valueLabel}',
                  repo.total.toStringAsFixed(0)),
              _tile(context, '${AppConfig.flagLabel} ${AppConfig.valueLabel}',
                  repo.flagTotal.toStringAsFixed(0)),
              _tile(context, 'Balance',
                  (repo.pendingTotal - repo.flagTotal).toStringAsFixed(0)),
            ],
            const SizedBox(height: 16),
            Text('By ${AppConfig.categoryLabel}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            CategoryChart(repo: repo),
          ],
        );
      },
    );
  }

  Widget _tile(BuildContext context, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
