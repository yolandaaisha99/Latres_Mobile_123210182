import 'package:hive/hive.dart';

part 'tv_show.g.dart';

@HiveType(typeId: 0)
class TvShow extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double? rating;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final List<String> genres;

  @HiveField(5)
  final String? summary;

  @HiveField(6)
  final String? mediumImageUrl;

  TvShow({
    required this.id,
    required this.name,
    this.rating,
    this.imageUrl,
    required this.genres,
    this.summary,
    this.mediumImageUrl,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'];
    double? rating;
    if (ratingMap != null && ratingMap['average'] != null) {
      rating = (ratingMap['average'] as num).toDouble();
    }

    final imageMap = json['image'];
    String? imageUrl;
    String? mediumImageUrl;
    if (imageMap != null) {
      imageUrl = imageMap['original'];
      mediumImageUrl = imageMap['medium'];
    }

    final genresList = json['genres'] as List<dynamic>?;
    final genres = genresList?.map((e) => e.toString()).toList() ?? [];

    return TvShow(
      id: json['id'] as int,
      name: json['name'] as String,
      rating: rating,
      imageUrl: imageUrl,
      mediumImageUrl: mediumImageUrl,
      genres: genres,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': {'average': rating},
      'image': {'original': imageUrl, 'medium': mediumImageUrl},
      'genres': genres,
      'summary': summary,
    };
  }
}
