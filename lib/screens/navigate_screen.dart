import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/place.dart';
import '../state/campus_controller.dart';
import '../widgets/campus_map.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key, required this.controller, this.destination});
  final CampusController controller;
  final Place? destination;
  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  Place _from = CampusData.placeById('gate');
  late Place _to = widget.destination ?? CampusData.placeById('library');

  @override
  Widget build(BuildContext context) {
    final route = widget.controller.routes.route(_from, _to);
    return Scaffold(
      appBar: AppBar(title: const Text('Directions')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _picker('From', Icons.trip_origin, Colors.green, _from, (p) => setState(() => _from = p)),
        const SizedBox(height: 8),
        _picker('To', Icons.place, Colors.red, _to, (p) => setState(() => _to = p)),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(Icons.straighten, '${route.distance.round()} m', 'Distance'),
              _stat(Icons.directions_walk, '${route.minutes} min', 'Walking'),
              _stat(Icons.layers, _to.floor, 'Floor'),
            ]),
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(height: 300, child: CampusMap(highlight: _to.building, route: route.points)),
        ),
        const SizedBox(height: 12),
        Text('Step-by-step directions', style: Theme.of(context).textTheme.titleMedium),
        for (var i = 0; i < route.steps.length; i++)
          ListTile(
            dense: true,
            leading: CircleAvatar(radius: 12, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
            title: Text(route.steps[i]),
          ),
      ]),
    );
  }

  Widget _stat(IconData icon, String value, String label) => Column(children: [
        Icon(icon),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]);

  Widget _picker(String label, IconData icon, Color color, Place value, ValueChanged<Place> onChanged) {
    return DropdownButtonFormField<Place>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: color), border: const OutlineInputBorder()),
      items: [for (final p in CampusData.places) DropdownMenuItem(value: p, child: Text(p.name))],
      onChanged: (p) => p == null ? null : onChanged(p),
    );
  }
}
