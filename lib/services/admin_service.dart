import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../domain/entities/movie_config.dart';
import '../domain/entities/movie.dart';

class AdminService {
  static const String _keyMovieConfigs = 'admin_movie_configs';
  static const String _keyLastResetDate = 'last_reset_date';
  static const String _keyIsAdmin = 'isAdmin';

  // Check if user is admin
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAdmin) ?? false;
  }

  // Set admin status
  Future<void> setAdminStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAdmin, status);
  }

  // Save movie configurations (5 slots)
  Future<void> saveMovieConfigs(List<MovieConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = configs.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_keyMovieConfigs, jsonList);
  }

  // Get movie configurations
  Future<List<MovieConfig>> getMovieConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyMovieConfigs);
    
    if (jsonList == null || jsonList.isEmpty) {
      return _getDefaultMovieConfigs();
    }
    
    var movies = jsonList.map((json) => MovieConfig.fromJson(jsonDecode(json))).toList();
    
    // Migration fix for FNAF image
    bool needsUpdate = false;
    for (var i = 0; i < movies.length; i++) {
      if (movies[i].posterBase64 == 'assets/images/fnaf.jpg') {
        movies[i] = movies[i].copyWith(posterBase64: 'assets/images/fnaf2.jpg');
        needsUpdate = true;
      }
    }
    
    if (needsUpdate) {
      await saveMovieConfigs(movies);
    }
    
    return movies;
  }

  // Get as Movie entities for display
  Future<List<Movie>> getMoviesForDisplay() async {
    final configs = await getMovieConfigs();
    return configs.map((c) => c.toMovie()).toList();
  }

  // Check for midnight reset
  Future<void> checkAndResetIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(_keyLastResetDate);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    if (lastReset != today) {
      // Reset to default movies
      await resetToDefaultMovies();
      await prefs.setString(_keyLastResetDate, today);
    }
  }

  // Reset to default movies
  Future<void> resetToDefaultMovies() async {
    final defaults = _getDefaultMovieConfigs();
    await saveMovieConfigs(defaults);
  }

  // Force reset data (Manual trigger)
  Future<void> forceReset() async {
    await resetToDefaultMovies();
    final prefs = await SharedPreferences.getInstance();
    // Also reset the last reset date so it doesn't auto-reset again immediately if not needed
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString(_keyLastResetDate, today);
  }

  // Check for schedule conflicts
  bool hasScheduleConflict(int studioId, List<String> showtimes, List<MovieConfig> allConfigs, {String? excludeMovieId}) {
    for (var config in allConfigs) {
      if (excludeMovieId != null && config.id == excludeMovieId) continue;
      
      if (config.studioId == studioId) {
        for (var time in showtimes) {
          if (config.showtimes.contains(time)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Get available studios at a specific time
  List<int> getAvailableStudios(String time, List<MovieConfig> allConfigs, {String? excludeMovieId}) {
    final allStudios = [1, 2, 3, 4, 5];
    final usedStudios = <int>{};
    
    for (var config in allConfigs) {
      if (excludeMovieId != null && config.id == excludeMovieId) continue;
      if (config.showtimes.contains(time)) {
        usedStudios.add(config.studioId);
      }
    }
    
    return allStudios.where((s) => !usedStudios.contains(s)).toList();
  }

  // Default movie configurations (using placeholder data)
  List<MovieConfig> _getDefaultMovieConfigs() {
    final now = DateTime.now();
    return [
      MovieConfig(
        id: 'm1',
        title: 'Riba',
        posterBase64: 'assets/images/riba.jpg', // Will use asset initially
        synopsis: 'Film tentang bahaya riba dalam kehidupan modern',
        duration: 120,
        genres: ['Drama', 'Religion'],
        studioId: 1,
        showtimes: ['10:00', '13:00', '16:00', '19:00'],
        lastUpdated: now,
      ),
      MovieConfig(
        id: 'm2',
        title: 'Ozora',
        posterBase64: 'assets/images/ozora.jpg',
        synopsis: 'Petualangan fantasi di dunia Ozora',
        duration: 105,
        genres: ['Fantasy', 'Adventure'],
        studioId: 2,
        showtimes: ['11:00', '14:00', '17:00', '20:00'],
        lastUpdated: now,
      ),
      MovieConfig(
        id: 'm3',
        title: 'Dusun Mayit',
        posterBase64: 'assets/images/dusun_mayit.jpg',
        synopsis: 'Misteri horor di dusun terpencil',
        duration: 95,
        genres: ['Horror', 'Mystery'],
        studioId: 3,
        showtimes: ['12:00', '15:00', '18:00', '21:00'],
        lastUpdated: now,
      ),
      MovieConfig(
        id: 'm4',
        title: 'Wasiat Warisan',
        posterBase64: 'assets/images/wasiat_warisan.jpg',
        synopsis: 'Konflik keluarga tentang warisan',
        duration: 115,
        genres: ['Drama', 'Family'],
        studioId: 4,
        showtimes: ['10:30', '13:30', '16:30', '19:30'],
        lastUpdated: now,
      ),
      MovieConfig(
        id: 'm5',
        title: 'Five Nights at Freddys',
        posterBase64: 'assets/images/fnaf2.jpg',
        synopsis: 'Horor survival di pizzeria berhantu',
        duration: 110,
        genres: ['Horror', 'Thriller'],
        studioId: 5,
        showtimes: ['11:30', '14:30', '17:30', '20:30'],
        lastUpdated: now,
      ),
    ];
  }
}
