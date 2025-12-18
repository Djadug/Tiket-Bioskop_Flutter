import 'movie.dart';
import 'schedule.dart';
import 'seat.dart';
import 'user.dart';

enum PaymentStatus { pending, paid, failed }

class Ticket {
  final String id;
  final Movie movie;
  final Schedule schedule;
  final Seat seat;
  final User user;
  final String qrData;
  final PaymentStatus paymentStatus;
  final DateTime issuedAt;

  Ticket({
    required this.id,
    required this.movie,
    required this.schedule,
    required this.seat,
    required this.user,
    required this.qrData,
    required this.paymentStatus,
    required this.issuedAt,
  });
}


