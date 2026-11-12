import 'package:shared_preferences/shared_preferences.dart';

/// Saves favourites, recent searches and theme on the device.
class StorageService {
  static const _favKey = 'favourites';
  static const _recentKey = 'recent';
  static const _darkKey = 'dark_mode';

  Future<SharedPreferences> get _p => SharedPreferences.getInstance();

  Future<List<String>> loadFavourites() async => (await _p).getStringList(_favKey) ?? [];
  Future<void> saveFavourites(List<String> ids) async => (await _p).setStringList(_favKey, ids);

  Future<List<String>> loadRecent() async => (await _p).getStringList(_recentKey) ?? [];
  Future<void> saveRecent(List<String> ids) async => (await _p).setStringList(_recentKey, ids);

  Future<bool> loadDarkMode() async => (await _p).getBool(_darkKey) ?? false;
  Future<void> saveDarkMode(bool v) async => (await _p).setBool(_darkKey, v);
}
