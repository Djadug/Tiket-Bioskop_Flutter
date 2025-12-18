import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/booking.dart';

class BookingService {
  static const String _keyTickets = 'my_tickets';

  // Save a new ticket
  Future<void> saveTicket(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tickets = prefs.getStringList(_keyTickets) ?? [];
    tickets.add(jsonEncode(booking.toJson()));
    await prefs.setStringList(_keyTickets, tickets);
  }

  // Get all my tickets
  Future<List<Booking>> getMyTickets() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tickets = prefs.getStringList(_keyTickets) ?? [];
    return tickets.map((e) => Booking.fromJson(jsonDecode(e))).toList();
  }

  // Get reserved seats for a specific movie/schedule/time
  Future<Set<String>> getReservedSeats(String movieId, String scheduleId, String timeId) async {
    final allBookings = await getMyTickets();
    final reserved = <String>{};
    
    for (var booking in allBookings) {
      if (booking.movie.id == movieId && 
          booking.schedule.id == scheduleId && 
          booking.time.timeId == timeId) {
        for (var seat in booking.seats) {
          reserved.add(seat.id);
        }
      }
    }
    
    return reserved;
  }

  // Get ticket count for badge
  Future<int> getTicketCount() async {
    final tickets = await getMyTickets();
    return tickets.length;
  }
}
