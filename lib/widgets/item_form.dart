import 'package:flutter/material.dart';
import '../models/item.dart';
import '../data/repo.dart';
import '../config.dart';

class ItemForm extends StatefulWidget {
  final ItemRepo repo;
  final Item? existing;
  const ItemForm({super.key, required this.repo, this.existing});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  late final TextEditingController _title;
  late final TextEditingController _detail;
  late final TextEditingController _value;
  late final TextEditingController _category;
  bool _flag = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _title = TextEditingController(text: e?.title ?? '');
    _detail = TextEditingController(text: e?.detail ?? '');
    _value =
        TextEditingController(text: e == null ? '' : e.value.toStringAsFixed(0));
    _category = TextEditingController(text: e?.category ?? '');
    _flag = e?.flag ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _detail.dispose();
    _value.dispose();
    _category.dispose();
    super.dispose();
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }
    final detail = _detail.text.trim();
    final category = _category.text.trim();
    final value = double.tryParse(_value.text.trim()) ?? 0;
    final e = widget.existing;
    if (e == null) {
      widget.repo.add(title, detail, value, _flag, category);
    } else {
      widget.repo.update(e.id, title, detail, value, _flag, category);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit ${AppConfig.noun}' : 'New ${AppConfig.noun}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _detail,
            decoration: InputDecoration(
              labelText: AppConfig.detailLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _category,
            decoration: InputDecoration(
              labelText: AppConfig.categoryLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          if (AppConfig.usesValue) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _value,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppConfig.valueLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
          if (AppConfig.usesFlag) ...[
            const SizedBox(height: 6),
            SwitchListTile(
              title: Text(AppConfig.flagLabel),
              value: _flag,
              onChanged: (v) => setState(() => _flag = v),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
