import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../state/campus_controller.dart';
import '../widgets/campus_map.dart';
import '../widgets/place_tile.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.controller});
  final CampusController controller;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map')),
      body: CampusMap(
        highlight: _selected,
        onBuildingTap: (b) {
          setState(() => _selected = b.id);
          final inside = CampusData.places.where((p) => p.building == b.id).toList();
          showModalBottomSheet(
            context: context,
            builder: (_) => ListView(shrinkWrap: true, children: [
              ListTile(title: Text(b.name, style: Theme.of(context).textTheme.titleLarge),
                  subtitle: Text('${inside.length} places inside')),
              for (final p in inside) PlaceTile(place: p, controller: widget.controller),
              const SizedBox(height: 16),
            ]),
          );
        },
      ),
    );
  }
}
