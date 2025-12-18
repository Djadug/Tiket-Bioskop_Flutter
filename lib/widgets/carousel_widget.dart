import 'package:flutter/material.dart';
import '../domain/entities/movie.dart';

class CarouselMovie extends StatefulWidget {
  final List<Movie> movies;
  final Function(Movie) onTap;
  const CarouselMovie({Key? key, required this.movies, required this.onTap}) : super(key: key);

  @override
  State<CarouselMovie> createState() => _CarouselMovieState();
}

class _CarouselMovieState extends State<CarouselMovie> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 320, // Lebih tinggi untuk poster portrait
          child: PageView.builder(
            itemCount: widget.movies.length,
            controller: PageController(viewportFraction: 0.7),
            onPageChanged: (idx) => setState(() => currentIndex = idx),
            itemBuilder: (ctx, i) {
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => widget.onTap(widget.movies[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 270),
                  transform: Matrix4.identity()..scale(isActive ? 1.07 : 0.93),
                  margin: EdgeInsets.symmetric(horizontal: isActive ? 5 : 12, vertical: isActive ? 0 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: isActive ? Colors.black26 : Colors.black12,
                        blurRadius: isActive ? 18 : 7,
                        offset: const Offset(0,8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: AspectRatio(
                      aspectRatio: 0.68, // Portrait movie poster ratio
                      child: Image.asset(
                        widget.movies[i].poster,
                        fit: BoxFit.contain, // Agar poster tidak terpotong/pecah
                        filterQuality: FilterQuality.high,
                        errorBuilder: (ctx,_,__)=>
                          Container(color: Colors.grey[300], child: const Icon(Icons.local_movies_rounded, size:60)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
            (idx) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: 7,
              width: idx == currentIndex ? 28 : 7,
              decoration: BoxDecoration(
                color: idx==currentIndex ? Theme.of(context).colorScheme.primary : Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
