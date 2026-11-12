import 'package:flutter/foundation.dart';
import '../data/campus_data.dart';
import '../models/place.dart';
import '../services/route_service.dart';
import '../services/storage_service.dart';

/// Single source of truth for all screens.
class CampusController extends ChangeNotifier {
  CampusController(this._storage);

  final StorageService _storage;
  final RouteService routes = RouteService();

  final List<String> _favourites = [];
  final List<String> _recent = [];
  bool darkMode = false;

  List<Place> get all => CampusData.places;
  List<Place> get favourites => _favourites.map(CampusData.placeById).toList();
  List<Place> get recent => _recent.map(CampusData.placeById).toList();

  Future<void> load() async {
    _favourites..clear()..addAll(await _storage.loadFavourites());
    _recent..clear()..addAll(await _storage.loadRecent());
    darkMode = await _storage.loadDarkMode();
    notifyListeners();
  }

  List<Place> search(String query, {PlaceCategory? category}) => all
      .where((p) => (category == null || p.category == category) && p.matches(query))
      .toList();

  int countIn(PlaceCategory c) => all.where((p) => p.category == c).length;

  bool isFavourite(Place p) => _favourites.contains(p.id);

  Future<void> toggleFavourite(Place p) async {
    isFavourite(p) ? _favourites.remove(p.id) : _favourites.add(p.id);
    notifyListeners();
    await _storage.saveFavourites(_favourites);
  }

  /// Remembers the last 5 places the user opened.
  Future<void> markVisited(Place p) async {
    _recent
      ..remove(p.id)
      ..insert(0, p.id);
    if (_recent.length > 5) _recent.removeLast();
    notifyListeners();
    await _storage.saveRecent(_recent);
  }

  Future<void> setDarkMode(bool v) async {
    darkMode = v;
    notifyListeners();
    await _storage.saveDarkMode(v);
  }
}
