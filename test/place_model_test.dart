import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_navigator/data/campus_data.dart';

void main() {
  test('empty query matches every place', () {
    expect(CampusData.places.every((p) => p.matches('  ')), isTrue);
  });

  test('search is case-insensitive', () {
    expect(CampusData.placeById('library').matches('CENTRAL'), isTrue);
    expect(CampusData.placeById('a101').matches('c-101'), isTrue);
  });

  test('place ids are unique', () {
    final ids = CampusData.places.map((p) => p.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('every place points to a known building and junction', () {
    for (final p in CampusData.places) {
      expect(CampusData.nodes.containsKey(p.entranceNode), isTrue, reason: p.name);
      if (p.building != 'gate') {
        expect(CampusData.buildingById(p.building), isNotNull, reason: p.name);
      }
    }
  });
}
