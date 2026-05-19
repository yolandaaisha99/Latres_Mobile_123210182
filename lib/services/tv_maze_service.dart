import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tv_show.dart';

class TvMazeService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  /// Fetch list of shows from TVMaze
  static Future<List<TvShow>> fetchShows({int page = 0}) async {
    final uri = Uri.parse('$_baseUrl/shows?page=$page');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TvShow.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data shows: ${response.statusCode}');
    }
  }

  static Future<TvShow> fetchShowDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/shows/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TvShow.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail show: ${response.statusCode}');
    }
  }

  static Future<List<TvShow>> searchShows(String query) async {
    final uri = Uri.parse('$_baseUrl/search/shows?q=${Uri.encodeComponent(query)}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => TvShow.fromJson(item['show']))
          .toList();
    } else {
      throw Exception('Gagal mencari shows: ${response.statusCode}');
    }
  }
}
