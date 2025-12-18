import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'schedule_page.dart';

class MovieDetailPage extends StatelessWidget {
  static const String routeName = "/detail";
  final Movie movie;
  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Hero(
            tag: movie.poster,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                movie.poster,
                height: 320,
                fit: BoxFit.cover,
                errorBuilder: (ctx,_,__) => Container(
                    color: Colors.grey[300],
                    height: 320,
                    child: const Icon(Icons.local_movies_rounded, size: 88)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(movie.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 2,
            children: movie.genres.map((g) => Chip(label: Text(g))).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey),
              Text('  ${movie.duration} menit'),
              const SizedBox(width: 20),
              Icon(Icons.star_rounded, color: Colors.amber, size: 21),
              Text(' ${movie.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 18),
          Text("Sinopsis", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(
            movie.synopsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.event_seat_rounded),
              label: const Text("Pesan Tiket"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SchedulePage(movie: movie),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
