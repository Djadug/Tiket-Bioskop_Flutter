import 'dart:convert';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';

class Booking {
  final String id;
  final Movie movie;
  final Schedule schedule;
  final ScheduleTime time;
  final List<Seat> seats;
  final int price;
  final DateTime purchaseDate;

  Booking({
    required this.id,
    required this.movie,
    required this.schedule,
    required this.time,
    required this.seats,
    required this.price,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movie.id,
      'movieTitle': movie.title,
      'moviePoster': movie.poster,
      'scheduleId': schedule.id,
      'studioName': schedule.studioName,
      'timeId': time.timeId,
      'timeHour': time.time.hour,
      'timeMinute': time.time.minute,
      'seats': seats.map((s) => {'id': s.id, 'row': s.row, 'number': s.number}).toList(),
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return Booking(
      id: json['id'],
      movie: Movie(
        id: json['movieId'],
        title: json['movieTitle'],
        poster: json['moviePoster'],
        synopsis: '',
        duration: 0,
        rating: 0,
        genres: [],
      ),
      schedule: Schedule(
        id: json['scheduleId'],
        movieId: json['movieId'],
        date: now,
        timeslots: [],
        studioName: json['studioName'],
      ),
      time: ScheduleTime(
        timeId: json['timeId'],
        time: DateTime(now.year, now.month, now.day, json['timeHour'], json['timeMinute']),
      ),
      seats: (json['seats'] as List).map((s) => Seat(
        id: s['id'],
        row: s['row'],
        number: s['number'],
        isAvailable: false,
        isReserved: true,
        isSelected: false,
      )).toList(),
      price: json['price'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }
}
