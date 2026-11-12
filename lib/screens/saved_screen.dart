import 'package:flutter/material.dart';
import '../state/campus_controller.dart';
import '../widgets/place_tile.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.controller});
  final CampusController controller;

  @override
  Widget build(BuildContext context) {
    final saved = controller.favourites;
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Places')),
      body: saved.isEmpty
          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.bookmark_outline, size: 64),
              SizedBox(height: 8),
              Text('No saved places yet'),
              Text('Tap the bookmark on any place to save it'),
            ]))
          : ListView(children: [for (final p in saved) PlaceTile(place: p, controller: controller)]),
    );
  }
}
