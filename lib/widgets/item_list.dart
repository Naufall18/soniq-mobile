import 'package:flutter/material.dart';
import '../models/item.dart';
import '../data/repo.dart';
import '../config.dart';
import 'item_form.dart';

class ItemList extends StatelessWidget {
  final ItemRepo repo;
  final List<Item> Function() selector;
  const ItemList({super.key, required this.repo, required this.selector});

  void _openForm(BuildContext context, {Item? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ItemForm(repo: repo, existing: existing)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repo,
      builder: (context, _) {
        if (!repo.loaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = selector();
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Nothing here yet — tap + to add.'),
            ),
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final it = items[i];
            final sub = [
              if (it.detail.isNotEmpty) it.detail,
              if (it.category.isNotEmpty) it.category,
            ].join('  ·  ');
            return Dismissible(
              key: ValueKey(it.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => repo.remove(it.id),
              child: ListTile(
                leading: AppConfig.usesFlag
                    ? Checkbox(
                        value: it.flag, onChanged: (_) => repo.toggle(it.id))
                    : CircleAvatar(child: Text(it.title.characters.first)),
                title: Text(it.title),
                subtitle: sub.isEmpty ? null : Text(sub),
                trailing: AppConfig.usesValue
                    ? Text(
                        it.value.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () => _openForm(context, existing: it),
              ),
            );
          },
        );
      },
    );
  }
}
