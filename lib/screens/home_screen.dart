import 'package:flutter/material.dart';
import '../models/place.dart';
import '../state/campus_controller.dart';
import '../widgets/place_tile.dart';
import 'navigate_screen.dart';
import 'places_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller, required this.onOpenTab});
  final CampusController controller;
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: Text('Smart Campus\nNavigator',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                IconButton(
                  color: Colors.white,
                  tooltip: 'Dark mode',
                  icon: Icon(controller.darkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () => controller.setDarkMode(!controller.darkMode),
                ),
              ]),
              const SizedBox(height: 4),
              const Text('Find any classroom, lab or office in seconds',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                onTap: () => onOpenTab(2),
                decoration: InputDecoration(
                  hintText: 'Search places, rooms, labs...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              icon: const Icon(Icons.directions_walk),
              label: const Text('Get Directions'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NavigateScreen(controller: controller))),
            ),
          ),
          const _Header('Browse by category'),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final cat in PlaceCategory.values)
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => Scaffold(
                            appBar: AppBar(title: Text(cat.label)),
                            body: PlacesScreen(controller: controller, initialCategory: cat, showSearch: false),
                          ))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircleAvatar(backgroundColor: cat.color.withValues(alpha: 0.15), child: Icon(cat.icon, color: cat.color)),
                    const SizedBox(height: 4),
                    Text(cat.label, style: const TextStyle(fontSize: 12)),
                  ]),
                ),
            ],
          ),
          if (controller.recent.isNotEmpty) ...[
            const _Header('Recently viewed'),
            for (final p in controller.recent) PlaceTile(place: p, controller: controller),
          ],
          const _Header('Popular places'),
          for (final id in ['library', 'clab', 'canteen'])
            PlaceTile(place: controller.all.firstWhere((p) => p.id == id), controller: controller),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      );
}
