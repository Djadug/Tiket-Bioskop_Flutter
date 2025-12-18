import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../domain/entities/movie.dart';
import '../../services/booking_service.dart';
import '../../services/admin_service.dart';
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
  List<Movie> _movies = [];
  bool loading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadTicketCount();
    _loadMovies();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _loadMovies() async {
    final adminService = AdminService();
    
    // Check midnight reset
    await adminService.checkAndResetIfNeeded();
    
    // Load movies from admin config
    final movies = await adminService.getMoviesForDisplay();
    
    setState(() {
      _movies = movies;
      loading = false;
    });
  }

  Future<void> _loadTicketCount() async {
    final bookingService = BookingService();
    final count = await bookingService.getTicketCount();
    setState(() {
      ticketCount = count;
    });
  }



  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
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
            icon: Icon(
              _isLoggedIn ? Icons.logout : Icons.account_circle,
              color: Colors.black,
            ),
            onPressed: () async {
              if (_isLoggedIn) {
                // Logout Logic
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                setState(() => _isLoggedIn = false);
                
                // Optional: Force reload to guest state or navigate to login
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                }
              } else {
                // Login Logic
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInPage()),
                );
                // Refresh state on return
                _checkLoginStatus();
              }
            },
          ),
          if (_isLoggedIn)
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
                              _buildMovieImage(movie.poster, BoxFit.cover),
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

  // Helper method to build image from asset or base64
  Widget _buildMovieImage(String posterData, BoxFit fit) {
    if (posterData.startsWith('data:image') || posterData.contains('base64')) {
      // Base64 image
      try {
        final base64String = posterData.contains(',') ? posterData.split(',')[1] : posterData;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: (c, o, s) => Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.movie, size: 80, color: Colors.grey)),
          ),
        );
      } catch (e) {
        return Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.error, size: 80, color: Colors.red)),
        );
      }
    } else if (posterData.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        posterData,
        fit: fit,
        errorBuilder: (c, o, s) => Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.movie, size: 80, color: Colors.grey)),
        ),
      );
    }
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey)),
    );
  }
}
