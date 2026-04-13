import 'package:flutter/material.dart';
import 'config.dart';
import 'data/repo.dart';
import 'widgets/item_list.dart';
import 'widgets/item_form.dart';
import 'widgets/summary.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConfig.seedColor),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final ItemRepo _repo = ItemRepo();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _repo.load();
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ItemList(repo: _repo, selector: () => _repo.items),
      ItemList(
        repo: _repo,
        selector: () =>
            AppConfig.tab2Flagged ? _repo.flagged : _repo.pending,
      ),
      SummaryScreen(repo: _repo),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.appName)),
      body: pages[_index],
      floatingActionButton: _index == 2
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ItemForm(repo: _repo)),
              ),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: Icon(AppConfig.icon1), label: AppConfig.tab1),
          NavigationDestination(icon: Icon(AppConfig.icon2), label: AppConfig.tab2),
          NavigationDestination(icon: Icon(AppConfig.icon3), label: AppConfig.tab3),
        ],
      ),
    );
  }
}
