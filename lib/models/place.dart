import 'package:flutter/material.dart';

/// Kinds of places a student or visitor can look for on campus.
enum PlaceCategory {
  department('Departments', Icons.apartment, Color(0xFF3F51B5)),
  classroom('Classrooms', Icons.class_, Color(0xFF009688)),
  lab('Labs', Icons.science, Color(0xFFE65100)),
  library('Libraries', Icons.local_library, Color(0xFF6A1B9A)),
  office('Offices', Icons.badge, Color(0xFF455A64)),
  hall('Halls', Icons.event_seat, Color(0xFFC2185B)),
  facility('Facilities', Icons.local_cafe, Color(0xFF2E7D32));

  const PlaceCategory(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// A searchable location on campus (a building, room, lab, office ...).
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.building,
    required this.floor,
    required this.entranceNode,
    this.room = '',
    this.timings = '9:00 AM – 5:00 PM',
    this.description = '',
    this.tags = const [],
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final String building; // id of the building on the map
  final String floor;
  final String room;
  final String timings;
  final String description;
  final List<String> tags;

  /// Id of the road junction closest to the building entrance.
  final String entranceNode;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        room.toLowerCase().contains(q) ||
        category.label.toLowerCase().contains(q) ||
        tags.any((t) => t.toLowerCase().contains(q));
  }
}

/// A building drawn on the campus map (map units: 1 unit = 1 metre).
class Building {
  const Building(this.id, this.name, this.rect, this.color);
  final String id;
  final String name;
  final Rect rect;
  final Color color;
}
