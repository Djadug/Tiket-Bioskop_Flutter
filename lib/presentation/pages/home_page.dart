import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/movie.dart';
import '../../services/booking_service.dart';
import 'movie_detail_page.dart';
import 'my_tickets_page.dart';
import 'auth/sign_in_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int ticketCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTicketCount();
  }

  Future<void> _loadTicketCount() async {
    final bookingService = BookingService();
    final count = await bookingService.getTicketCount();
    setState(() {
      ticketCount = count;
    });
  }

  // Mock Data using the actual Movie entity structure
  final List<Movie> _movies = [
    Movie(
      id: 'm1',
      title: 'Riba',
      poster: 'assets/images/riba.jpg',
      synopsis: 'Teror mengerikan akibat hutang yang membawa petaka bagi keluarga...',
      duration: 105,
      rating: 4.5,
      genres: ['Horor', 'Drama'],
    ),
    Movie(
      id: 'm2',
      title: 'Ozora: Penganiayaan Brutal',
      poster: 'assets/images/ozora.jpg',
      synopsis: 'Kisah nyata penganiayaan brutal yang mengguncang publik...',
      duration: 110,
      rating: 4.2,
      genres: ['Drama', 'Crime'],
    ),
    Movie(
      id: 'm3',
      title: 'Wasiat Warisan',
      poster: 'assets/images/wasiat_warisan.jpg',
      synopsis: 'Perebutan harta warisan yang berujung pada malapetaka...',
      duration: 95,
      rating: 3.8,
      genres: ['Komedi', 'Horor'],
    ),
    Movie(
      id: 'm4',
      title: 'Five Nights at Freddy\'s',
      poster: 'assets/images/fnaf2.jpg',
      synopsis: 'Selamat datang kembali di pengalaman horor klasik...',
      duration: 115,
      rating: 4.0,
      genres: ['Horor', 'Thriller'],
    ),
    Movie(
      id: 'm5',
      title: 'Dusun Mayit',
      poster: 'assets/images/dusun_mayit.jpg',
      synopsis: 'Misteri desa terpencil yang menyimpan rahasia kelam...',
      duration: 100,
      rating: 4.1,
      genres: ['Horor'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Film Bioskop',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
               // Logout Logic
               final prefs = await SharedPreferences.getInstance();
               await prefs.setBool('isLoggedIn', false);
               if (context.mounted) {
                 Navigator.of(context).pushReplacement(
                   MaterialPageRoute(builder: (_) => const SignInPage()),
                 );
               }
            },
          ),
          IconButton(
            icon: Badge(
              label: Text('$ticketCount'),
              isLabelVisible: ticketCount > 0,
              child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyTicketsPage()),
              );
              // Reload ticket count when returning
              _loadTicketCount();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. Feature Carousel (Top 3 movies)
            CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.75,
                aspectRatio: 3 / 4,
                enableInfiniteScroll: true,
              ),
              items: _movies.take(3).map((movie) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _navigateToDetail(movie),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                               // Use a colored container as placeholder if asset fails, or actual image
                              Container(color: Colors.grey[200]),
                              Image.asset(
                                movie.poster,
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => const Center(
                                  child: Icon(Icons.movie, size: 80, color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [Colors.black87, Colors.transparent],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // 2. "Semua Film" Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Semua Film',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 3. Grid of all movies
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _navigateToDetail(movie),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 4,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.asset(
                                  movie.poster,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3, // Increased flex for info area
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16, // Larger title
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Rating & Duration row
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 16, color: Colors.amber),
                                        Text(
                                          ' ${movie.rating}',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                        Text(
                                          ' ${movie.duration}m',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      movie.genres.join(', '),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailPage(movie: movie)),
    );
  }
}
