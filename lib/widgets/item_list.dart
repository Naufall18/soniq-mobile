import 'package:flutter/material.dart';
import '../models/item.dart';
import '../data/repo.dart';
import '../config.dart';
import 'item_form.dart';

class ItemList extends StatefulWidget {
  final ItemRepo repo;
  final List<Item> Function() selector;
  const ItemList({super.key, required this.repo, required this.selector});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  bool _sortAz = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openForm(BuildContext context, {Item? existing}) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => ItemForm(repo: widget.repo, existing: existing)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repo,
      builder: (context, _) {
        if (!widget.repo.loaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final q = _query.trim().toLowerCase();
        var items = widget.selector();
        if (q.isNotEmpty) {
          items = items
              .where((it) =>
                  it.title.toLowerCase().contains(q) ||
                  it.detail.toLowerCase().contains(q))
              .toList();
        }
        if (_sortAz) {
          items = List.of(items)
            ..sort((a, b) =>
                a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search ${AppConfig.noun.toLowerCase()}s',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => setState(() {
                                  _query = '';
                                  _search.clear();
                                }),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: _sortAz ? 'Sorted A–Z' : 'Sort A–Z',
                    isSelected: _sortAz,
                    icon: const Icon(Icons.sort_by_alpha),
                    onPressed: () => setState(() => _sortAz = !_sortAz),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildList(context, items)),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext context, List<Item> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_query.isEmpty
              ? 'Nothing here yet — tap + to add.'
              : 'No matches for "$_query".'),
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
          onDismissed: (_) => widget.repo.remove(it.id),
          child: ListTile(
            leading: AppConfig.usesFlag
                ? Checkbox(
                    value: it.flag,
                    onChanged: (_) => widget.repo.toggle(it.id))
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
  }
}
