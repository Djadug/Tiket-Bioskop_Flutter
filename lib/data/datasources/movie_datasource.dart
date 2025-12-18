import 'dart:async';
import '../models/movie_model.dart';

class MovieDatasource {
  Future<List<MovieModel>> getMovies() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      MovieModel(
        id: '1',
        title: 'Ozora: Penganiayaan Brutal Penguasa Jaksel',
        poster: 'assets/images/ozora.jpg',
        synopsis: 'Perjuangan orang tua menuntut keadilan atas kasus penganiayaan elite yang viral.',
        duration: 125,
        rating: 8.8,
        genres: ['Drama', 'Thriller'],
      ),
      MovieModel(
        id: '2',
        title: 'Riba',
        poster: 'assets/images/riba.jpg',
        synopsis: 'Hidup Sugi berubah drastis karena hutang riba dan teror mistis pesugihan.',
        duration: 110,
        rating: 8.3,
        genres: ['Horor', 'Sosial'],
      ),
      MovieModel(
        id: '3',
        title: 'Wasiat Warisan',
        poster: 'assets/images/wasiat_warisan.jpg',
        synopsis: 'Tiga saudara menghadapi rahasia, hutang, dan cinta lama dalam hotel warisan keluarga.',
        duration: 117,
        rating: 7.9,
        genres: ['Drama', 'Family'],
      ),
      MovieModel(
        id: '4',
        title: "Five Nights at Freddy’s 2: Kengerian Animatronik",
        poster: 'assets/images/fnaf2.jpg',
        synopsis: 'Sekuel horor animatronik, Abby dan teman-teman menghadapi teror baru di Freddy Fazbear’s.',
        duration: 100,
        rating: 8.0,
        genres: ['Horor', 'Thriller'],
      ),
      MovieModel(
        id: '5',
        title: 'Dusun Mayit: Petualangan Misterius',
        poster: 'assets/images/dusun_mayit.jpg',
        synopsis: 'Petualangan mahasiswa di Gunung Welirang berubah menakutkan di dusun misterius.',
        duration: 114,
        rating: 7.8,
        genres: ['Horor', 'Adventure'],
      ),
    ];
  }
}
