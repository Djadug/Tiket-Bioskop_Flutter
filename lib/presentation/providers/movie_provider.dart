import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';
import '../../data/datasources/movie_datasource.dart';
import '../../data/repositories/movie_repository_impl.dart';

final getMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final datasource = MovieDatasource();
  final repository = MovieRepositoryImpl(datasource);
  final usecase = GetMovies(repository);
  return await usecase();
});


