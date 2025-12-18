import '../../domain/entities/ticket.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/user.dart';

class TicketModel extends Ticket {
  TicketModel({
    required super.id,
    required super.movie,
    required super.schedule,
    required super.seat,
    required super.user,
    required super.qrData,
    required super.paymentStatus,
    required super.issuedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: json['id'],
        movie: Movie(
          id: json['movie']['id'],
          title: json['movie']['title'],
          poster: json['movie']['poster'],
          synopsis: json['movie']['synopsis'],
          duration: json['movie']['duration'],
          rating: (json['movie']['rating'] as num).toDouble(),
          genres: List<String>.from(json['movie']['genres']),
        ),
        schedule: Schedule(
          id: json['schedule']['id'],
          movieId: json['schedule']['movieId'],
          date: DateTime.parse(json['schedule']['date']),
          timeslots: [],
          studioName: json['schedule']['studioName'],
        ),
        seat: Seat(
          id: json['seat']['id'],
          row: json['seat']['row'],
          number: json['seat']['number'],
          isAvailable: json['seat']['isAvailable'],
        ),
        user: User(
          id: json['user']['id'],
          name: json['user']['name'],
          email: json['user']['email'],
        ),
        qrData: json['qrData'],
        paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['paymentStatus']),
        issuedAt: DateTime.parse(json['issuedAt']),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'movie': {
      'id': movie.id,
      'title': movie.title,
      'poster': movie.poster,
      'synopsis': movie.synopsis,
      'duration': movie.duration,
      'rating': movie.rating,
      'genres': movie.genres,
    },
    'schedule': {
      'id': schedule.id,
      'movieId': schedule.movieId,
      'date': schedule.date.toIso8601String(),
      'studioName': schedule.studioName,
    },
    'seat': {
      'id': seat.id,
      'row': seat.row,
      'number': seat.number,
      'isAvailable': seat.isAvailable,
    },
    'user': {
      'id': user.id,
      'name': user.name,
      'email': user.email,
    },
    'qrData': qrData,
    'paymentStatus': paymentStatus.name,
    'issuedAt': issuedAt.toIso8601String(),
  };
}


