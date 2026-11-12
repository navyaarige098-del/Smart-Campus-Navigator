import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_campus_navigator/models/place.dart';
import 'package:smart_campus_navigator/services/storage_service.dart';
import 'package:smart_campus_navigator/state/campus_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('search by name, room and tag', () {
    final c = CampusController(StorageService());
    expect(c.search('library').length, 2);
    expect(c.search('C-101').single.id, 'a101');
    expect(c.search('food').single.id, 'canteen');
  });

  test('filter by category', () {
    final c = CampusController(StorageService());
    expect(c.search('', category: PlaceCategory.lab).length, 4);
  });

  test('favourites are saved and reloaded', () async {
    final c = CampusController(StorageService());
    await c.toggleFavourite(c.all.first);
    final c2 = CampusController(StorageService());
    await c2.load();
    expect(c2.favourites.single.id, c.all.first.id);
  });

  test('recent list keeps the latest 5', () async {
    final c = CampusController(StorageService());
    for (final p in c.all.take(7)) {
      await c.markVisited(p);
    }
    expect(c.recent.length, 5);
    expect(c.recent.first.id, c.all[6].id);
  });
}
