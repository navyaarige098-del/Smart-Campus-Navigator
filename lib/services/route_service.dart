import 'dart:math';
import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/place.dart';

/// Result of a route search between two places.
class CampusRoute {
  const CampusRoute(this.points, this.distance, this.steps);
  final List<Offset> points; // polyline in map coordinates
  final double distance; // metres
  final List<String> steps; // human-readable directions

  /// Walking time at an average speed of 1.2 m/s.
  int get minutes => max(1, (distance / 1.2 / 60).round());
}

/// Finds the shortest walking route on the campus road graph (Dijkstra).
class RouteService {
  RouteService({Map<String, Offset>? nodes, List<List<String>>? roads})
      : _nodes = nodes ?? CampusData.nodes {
    for (final r in roads ?? CampusData.roads) {
      final d = (_nodes[r[0]]! - _nodes[r[1]]!).distance;
      _adj.putIfAbsent(r[0], () => {})[r[1]] = d;
      _adj.putIfAbsent(r[1], () => {})[r[0]] = d;
    }
  }

  final Map<String, Offset> _nodes;
  final Map<String, Map<String, double>> _adj = {};

  /// Shortest list of node ids from [from] to [to], or empty if unreachable.
  List<String> shortestPath(String from, String to) {
    final dist = <String, double>{for (final n in _nodes.keys) n: double.infinity};
    final prev = <String, String>{};
    final open = <String>{..._nodes.keys};
    dist[from] = 0;
    while (open.isNotEmpty) {
      final u = open.reduce((a, b) => dist[a]! <= dist[b]! ? a : b);
      if (dist[u] == double.infinity || u == to) break;
      open.remove(u);
      for (final e in (_adj[u] ?? {}).entries) {
        final alt = dist[u]! + e.value;
        if (alt < dist[e.key]!) {
          dist[e.key] = alt;
          prev[e.key] = u;
        }
      }
    }
    if (from != to && !prev.containsKey(to)) return [];
    final path = <String>[to];
    while (path.first != from) {
      path.insert(0, prev[path.first]!);
    }
    return path;
  }

  CampusRoute route(Place from, Place to) {
    final ids = shortestPath(from.entranceNode, to.entranceNode);
    final pts = ids.map((id) => _nodes[id]!).toList();
    var total = 0.0;
    for (var i = 1; i < pts.length; i++) {
      total += (pts[i] - pts[i - 1]).distance;
    }
    return CampusRoute(pts, total, _directions(from, to, pts));
  }

  List<String> _directions(Place from, Place to, List<Offset> pts) {
    final steps = <String>['Start at ${from.name}'];
    var i = 1;
    while (i < pts.length) {
      final dir = _heading(pts[i] - pts[i - 1]);
      var d = 0.0;
      // merge consecutive segments going the same way
      while (i < pts.length && _heading(pts[i] - pts[i - 1]) == dir) {
        d += (pts[i] - pts[i - 1]).distance;
        i++;
      }
      steps.add('Walk ${d.round()} m $dir');
    }
    final floor = to.floor == 'Ground' ? 'ground floor' : '${to.floor} floor';
    final b = CampusData.buildingById(to.building)?.name ?? to.name;
    steps.add('Arrive at ${to.name} – $b, $floor${to.room.isEmpty ? '' : ', room ${to.room}'}');
    return steps;
  }

  static String _heading(Offset v) {
    if (v.dx.abs() > v.dy.abs()) return v.dx > 0 ? 'east' : 'west';
    return v.dy > 0 ? 'south' : 'north';
  }
}
