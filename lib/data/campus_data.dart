import 'package:flutter/material.dart';
import '../models/place.dart';

/// Offline campus model: road junctions, roads, buildings and places.
class CampusData {
  static const Size mapSize = Size(400, 600);

  /// Road junctions (graph nodes) in map coordinates.
  static const Map<String, Offset> nodes = {
    'm0': Offset(200, 570), // main gate
    'm1': Offset(200, 470),
    'm2': Offset(200, 380),
    'm3': Offset(200, 270),
    'm4': Offset(200, 160),
    'm5': Offset(200, 90),
    'l2': Offset(100, 380), 'r2': Offset(300, 380),
    'l3': Offset(100, 270), 'r3': Offset(300, 270),
    'l4': Offset(100, 160), 'r4': Offset(300, 160),
  };

  /// Walkable road segments (undirected graph edges).
  static const List<List<String>> roads = [
    ['m0', 'm1'], ['m1', 'm2'], ['m2', 'm3'], ['m3', 'm4'], ['m4', 'm5'],
    ['l2', 'm2'], ['m2', 'r2'],
    ['l3', 'm3'], ['m3', 'r3'],
    ['l4', 'm4'], ['m4', 'r4'],
    ['l2', 'l3'], ['r2', 'r3'], // side walkways
  ];

  static const List<Building> buildings = [
    Building('admin', 'Admin Block', Rect.fromLTWH(220, 440, 110, 60), Color(0xFF90A4AE)),
    Building('parking', 'Parking', Rect.fromLTWH(70, 440, 110, 60), Color(0xFFBDBDBD)),
    Building('library', 'Library Block', Rect.fromLTWH(45, 300, 110, 62), Color(0xFFB39DDB)),
    Building('cse', 'CSE Block', Rect.fromLTWH(245, 300, 110, 62), Color(0xFF9FA8DA)),
    Building('science', 'Science Block', Rect.fromLTWH(45, 190, 110, 62), Color(0xFFFFCC80)),
    Building('ece', 'ECE Block', Rect.fromLTWH(245, 190, 110, 62), Color(0xFF80CBC4)),
    Building('canteen', 'Canteen', Rect.fromLTWH(45, 85, 110, 57), Color(0xFFA5D6A7)),
    Building('mech', 'Mechanical Block', Rect.fromLTWH(245, 85, 110, 57), Color(0xFFFFAB91)),
    Building('auditorium', 'Auditorium', Rect.fromLTWH(140, 22, 120, 50), Color(0xFFF48FB1)),
  ];

  static const List<Place> places = [
    Place(id: 'gate', name: 'Main Gate', category: PlaceCategory.facility, building: 'gate', floor: 'Ground', entranceNode: 'm0', timings: 'Open 24 hours', description: 'Main entry for students and visitors. Security desk and visitor register.', tags: ['entry', 'security']),
    Place(id: 'admin', name: 'Administrative Office', category: PlaceCategory.office, building: 'admin', floor: 'Ground', room: 'A-001', entranceNode: 'm1', description: 'Admissions, fee payment, certificates and ID cards.', tags: ['fees', 'admission', 'id card']),
    Place(id: 'exam', name: 'Examination Cell', category: PlaceCategory.office, building: 'admin', floor: '1st', room: 'A-104', entranceNode: 'm1', description: 'Hall tickets, results and revaluation.', tags: ['hall ticket', 'results']),
    Place(id: 'parking', name: 'Vehicle Parking', category: PlaceCategory.facility, building: 'parking', floor: 'Ground', entranceNode: 'm1', timings: '7:00 AM – 7:00 PM', tags: ['bike', 'car']),
    Place(id: 'library', name: 'Central Library', category: PlaceCategory.library, building: 'library', floor: 'Ground', room: 'L-001', entranceNode: 'l2', timings: '8:30 AM – 8:00 PM', description: '40,000+ books, journals and a quiet reading hall.', tags: ['books', 'reading']),
    Place(id: 'dlib', name: 'Digital Library', category: PlaceCategory.library, building: 'library', floor: '1st', room: 'L-101', entranceNode: 'l2', description: 'Computers with e-journal access (IEEE, Springer, NPTEL).', tags: ['e-books', 'internet']),
    Place(id: 'cse', name: 'CSE Department', category: PlaceCategory.department, building: 'cse', floor: 'Ground', room: 'C-001', entranceNode: 'r2', description: 'Computer Science and Engineering – HoD office and staff rooms.', tags: ['computer science', 'hod']),
    Place(id: 'a101', name: 'Classroom C-101', category: PlaceCategory.classroom, building: 'cse', floor: '1st', room: 'C-101', entranceNode: 'r2', description: 'III Year CSE – Section A.', tags: ['class', 'cse']),
    Place(id: 'a204', name: 'Classroom C-204', category: PlaceCategory.classroom, building: 'cse', floor: '2nd', room: 'C-204', entranceNode: 'r2', description: 'II Year CSE – Section B.', tags: ['class', 'cse']),
    Place(id: 'clab', name: 'Computer Lab 1', category: PlaceCategory.lab, building: 'cse', floor: 'Ground', room: 'C-010', entranceNode: 'r2', description: '72 systems – programming and project lab.', tags: ['computers', 'programming']),
    Place(id: 'ece', name: 'ECE Department', category: PlaceCategory.department, building: 'ece', floor: 'Ground', room: 'E-001', entranceNode: 'r3', description: 'Electronics and Communication Engineering.', tags: ['electronics', 'hod']),
    Place(id: 'elab', name: 'Electronics Lab', category: PlaceCategory.lab, building: 'ece', floor: '1st', room: 'E-110', entranceNode: 'r3', tags: ['circuits']),
    Place(id: 'plab', name: 'Physics Lab', category: PlaceCategory.lab, building: 'science', floor: 'Ground', room: 'S-005', entranceNode: 'l3', tags: ['physics', 'first year']),
    Place(id: 'chlab', name: 'Chemistry Lab', category: PlaceCategory.lab, building: 'science', floor: '1st', room: 'S-102', entranceNode: 'l3', tags: ['chemistry', 'first year']),
    Place(id: 'canteen', name: 'Canteen', category: PlaceCategory.facility, building: 'canteen', floor: 'Ground', entranceNode: 'l4', timings: '8:00 AM – 6:00 PM', tags: ['food', 'cafe']),
    Place(id: 'mech', name: 'Mechanical Department', category: PlaceCategory.department, building: 'mech', floor: 'Ground', room: 'M-001', entranceNode: 'r4', tags: ['mechanical', 'workshop']),
    Place(id: 'audi', name: 'Auditorium', category: PlaceCategory.hall, building: 'auditorium', floor: 'Ground', entranceNode: 'm5', description: '800-seat hall for events, fests and guest lectures.', tags: ['events', 'fest']),
    Place(id: 'seminar', name: 'Seminar Hall', category: PlaceCategory.hall, building: 'library', floor: '2nd', room: 'L-201', entranceNode: 'l2', description: '150-seat hall with projector.', tags: ['workshop', 'talk']),
  ];

  static Place placeById(String id) => places.firstWhere((p) => p.id == id);

  static Building? buildingById(String id) {
    for (final b in buildings) {
      if (b.id == id) return b;
    }
    return null;
  }
}
