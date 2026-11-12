import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/place.dart';
import '../state/campus_controller.dart';
import '../widgets/campus_map.dart';
import 'navigate_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place, required this.controller});
  final Place place;
  final CampusController controller;

  @override
  Widget build(BuildContext context) {
    final building = CampusData.buildingById(place.building)?.name ?? place.name;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: Text(place.name), actions: [
          IconButton(
            icon: Icon(controller.isFavourite(place) ? Icons.bookmark : Icons.bookmark_outline),
            onPressed: () => controller.toggleFavourite(place),
          ),
        ]),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(height: 260, child: CampusMap(highlight: place.building)),
          ),
          const SizedBox(height: 16),
          Chip(avatar: Icon(place.category.icon, size: 18), label: Text(place.category.label)),
          if (place.description.isNotEmpty) Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(place.description, style: Theme.of(context).textTheme.bodyLarge),
          ),
          _info(Icons.business, 'Building', building),
          _info(Icons.layers, 'Floor', place.floor),
          if (place.room.isNotEmpty) _info(Icons.meeting_room, 'Room', place.room),
          _info(Icons.schedule, 'Timings', place.timings),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.directions_walk),
            label: const Text('Navigate here'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => NavigateScreen(controller: controller, destination: place))),
          ),
        ]),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) =>
      ListTile(contentPadding: EdgeInsets.zero, leading: Icon(icon), title: Text(label), subtitle: Text(value));
}
