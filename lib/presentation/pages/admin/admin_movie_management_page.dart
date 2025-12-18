import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../../../services/admin_service.dart';
import '../../../domain/entities/movie_config.dart';
import 'admin_movie_form_page.dart';

class AdminMovieManagementPage extends StatefulWidget {
  const AdminMovieManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminMovieManagementPage> createState() => _AdminMovieManagementPageState();
}

class _AdminMovieManagementPageState extends State<AdminMovieManagementPage> {
  List<MovieConfig> movies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final adminService = AdminService();
    final configs = await adminService.getMovieConfigs();
    setState(() {
      movies = configs;
      loading = false;
    });
  }

  Future<void> _editMovie(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminMovieFormPage(
          movieConfig: movies[index],
          slotIndex: index,
          allMovies: movies,
        ),
      ),
    );
    
    if (result == true) {
      _loadMovies(); // Reload
    }
  }

  Future<void> _addNewMovie(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminMovieFormPage(
          slotIndex: index,
          allMovies: movies,
        ),
      ),
    );
    
    if (result == true) {
      _loadMovies(); // Reload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Film'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // 5 slots
              itemBuilder: (context, index) {
                if (index < movies.length) {
                  return _buildMovieCard(movies[index], index);
                } else {
                  return _buildEmptySlot(index);
                }
              },
            ),
    );
  }

  Widget _buildMovieCard(MovieConfig movie, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: _buildPoster(movie.posterBase64),
        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Studio ${movie.studioId} • ${movie.duration} menit'),
            Text('Jam: ${movie.showtimes.join(", ")}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _editMovie(index),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildEmptySlot(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 70,
          color: Colors.grey[300],
          child: const Icon(Icons.add_photo_alternate, color: Colors.grey),
        ),
        title: Text('Slot ${index + 1} - Kosong'),
        subtitle: const Text('Tap untuk menambah film'),
        trailing: const Icon(Icons.add_circle, color: Colors.green),
        onTap: () => _addNewMovie(index),
      ),
    );
  }

  Widget _buildPoster(String posterData) {
    if (posterData.startsWith('data:image') || posterData.contains('base64')) {
      // Base64 image
      try {
        final base64String = posterData.contains(',') ? posterData.split(',')[1] : posterData;
        final bytes = base64Decode(base64String);
        return Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        return _buildPlaceholder();
      }
    } else if (posterData.startsWith('assets/')) {
      // Asset image
      return Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            posterData,
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => _buildPlaceholder(),
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.movie, color: Colors.grey),
    );
  }
}
