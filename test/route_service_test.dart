import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_navigator/data/campus_data.dart';
import 'package:smart_campus_navigator/services/route_service.dart';

void main() {
  final service = RouteService();
  const p = CampusData.placeById;

  test('shortest path from gate to CSE block', () {
    expect(service.shortestPath('m0', 'r2'), ['m0', 'm1', 'm2', 'r2']);
  });

  test('route distance and walking time', () {
    final r = service.route(p('gate'), p('clab'));
    expect(r.distance, 290);
    expect(r.minutes, 4);
  });

  test('directions merge straight segments', () {
    final r = service.route(p('gate'), p('clab'));
    expect(r.steps[1], 'Walk 190 m north');
    expect(r.steps[2], 'Walk 100 m east');
    expect(r.steps.last, contains('room C-010'));
  });

  test('same place gives zero distance', () {
    expect(service.route(p('library'), p('dlib')).distance, 0);
  });

  test('every place entrance is reachable from the gate', () {
    for (final p in CampusData.places) {
      expect(service.shortestPath('m0', p.entranceNode), isNotEmpty, reason: p.name);
    }
  });
}
