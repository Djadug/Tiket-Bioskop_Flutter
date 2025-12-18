import 'movie.dart';

class MovieConfig {
  final String id;
  final String title;
  final String posterBase64; // Base64 encoded image
  final String synopsis;
  final int duration; // in minutes
  final List<String> genres; // 2 categories
  final int studioId; // 1-5
  final List<String> showtimes; // ["10:00", "13:00", "16:00"]
  final DateTime lastUpdated;

  MovieConfig({
    required this.id,
    required this.title,
    required this.posterBase64,
    required this.synopsis,
    required this.duration,
    required this.genres,
    required this.studioId,
    required this.showtimes,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterBase64': posterBase64,
      'synopsis': synopsis,
      'duration': duration,
      'genres': genres,
      'studioId': studioId,
      'showtimes': showtimes,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory MovieConfig.fromJson(Map<String, dynamic> json) {
    return MovieConfig(
      id: json['id'],
      title: json['title'],
      posterBase64: json['posterBase64'],
      synopsis: json['synopsis'],
      duration: json['duration'],
      genres: List<String>.from(json['genres']),
      studioId: json['studioId'],
      showtimes: List<String>.from(json['showtimes']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  // CopyWith method
  MovieConfig copyWith({
    String? id,
    String? title,
    String? posterBase64,
    String? synopsis,
    int? duration,
    List<String>? genres,
    int? studioId,
    List<String>? showtimes,
    DateTime? lastUpdated,
  }) {
    return MovieConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      posterBase64: posterBase64 ?? this.posterBase64,
      synopsis: synopsis ?? this.synopsis,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      studioId: studioId ?? this.studioId,
      showtimes: showtimes ?? this.showtimes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Convert to Movie entity for display
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      poster: posterBase64, // Will be used as base64 in Image.memory
      synopsis: synopsis,
      duration: duration,
      rating: 0,
      genres: genres,
    );
  }
}
