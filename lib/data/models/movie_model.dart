import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.poster,
    required super.synopsis,
    required super.duration,
    required super.rating,
    required super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'],
    title: json['title'],
    poster: json['poster'],
    synopsis: json['synopsis'],
    duration: json['duration'],
    rating: (json['rating'] as num).toDouble(),
    genres: List<String>.from(json['genres']),
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'poster': poster,
    'synopsis': synopsis,
    'duration': duration,
    'rating': rating,
    'genres': genres,
  };
}


