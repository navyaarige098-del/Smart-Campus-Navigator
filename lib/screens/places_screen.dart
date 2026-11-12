import 'package:flutter/material.dart';
import '../models/place.dart';
import '../state/campus_controller.dart';
import '../widgets/place_tile.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key, required this.controller, this.initialCategory, this.showSearch = true});
  final CampusController controller;
  final PlaceCategory? initialCategory;
  final bool showSearch;
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String _query = '';
  late PlaceCategory? _category = widget.initialCategory;

  @override
  Widget build(BuildContext context) {
    final results = widget.controller.search(_query, category: _category);
    return SafeArea(
      child: Column(children: [
        if (widget.showSearch) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, room or keyword',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
              Padding(padding: const EdgeInsets.all(4), child: ChoiceChip(
                  label: const Text('All'), selected: _category == null,
                  onSelected: (_) => setState(() => _category = null))),
              for (final c in PlaceCategory.values)
                Padding(padding: const EdgeInsets.all(4), child: ChoiceChip(
                    avatar: Icon(c.icon, size: 18), label: Text(c.label), selected: _category == c,
                    onSelected: (_) => setState(() => _category = c))),
            ]),
          ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Align(alignment: Alignment.centerLeft, child: Text('${results.length} places found')),
        ),
        Expanded(
          child: results.isEmpty
              ? const Center(child: Text('No places match your search'))
              : ListView(children: [for (final p in results) PlaceTile(place: p, controller: widget.controller)]),
        ),
      ]),
    );
  }
}
