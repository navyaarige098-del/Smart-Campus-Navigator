import 'package:flutter/material.dart';
import '../state/campus_controller.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'places_screen.dart';
import 'saved_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});
  final CampusController controller;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final pages = [
      HomeScreen(controller: c, onOpenTab: (i) => setState(() => _index = i)),
      MapScreen(controller: c),
      PlacesScreen(controller: c),
      SavedScreen(controller: c),
    ];
    return Scaffold(
      body: ListenableBuilder(listenable: c, builder: (_, __) => pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Places'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
        ],
      ),
    );
  }
}
