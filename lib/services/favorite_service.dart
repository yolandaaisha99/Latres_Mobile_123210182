import 'package:hive_flutter/hive_flutter.dart';
import '../models/tv_show.dart';

class FavoriteService {
  static const String _boxName = 'favorites';

  static Box<TvShow> get _box => Hive.box<TvShow>(_boxName);

  static Future<void> init() async {
    await Hive.openBox<TvShow>(_boxName);
  }

  static List<TvShow> getFavorites() {
    return _box.values.toList();
  }

  static bool isFavorite(int showId) {
    return _box.containsKey(showId);
  }

  static Future<void> addFavorite(TvShow show) async {
    await _box.put(show.id, show);
  }

  static Future<void> removeFavorite(int showId) async {
    await _box.delete(showId);
  }

  static Future<void> toggleFavorite(TvShow show) async {
    if (isFavorite(show.id)) {
      await removeFavorite(show.id);
    } else {
      await addFavorite(show);
    }
  }
}
