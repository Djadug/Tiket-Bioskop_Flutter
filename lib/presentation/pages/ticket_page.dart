import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/booking.dart';
import '../../services/booking_service.dart';
import 'dart:convert';
import 'home_page.dart';

class TicketPage extends StatefulWidget {
  static const String routeName = "/ticket";
  final Movie movie;
  final Schedule schedule;
  final ScheduleTime time;
  final List<Seat> seats;
  final int price;
  const TicketPage({Key? key, required this.movie, required this.schedule, required this.time, required this.seats, required this.price}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    _saveBooking();
  }

  Future<void> _saveBooking() async {
    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      movie: widget.movie,
      schedule: widget.schedule,
      time: widget.time,
      seats: widget.seats,
      price: widget.price,
      purchaseDate: DateTime.now(),
    );
    
    final bookingService = BookingService();
    await bookingService.saveTicket(booking);
  }

  @override
  Widget build(BuildContext context) {
    final kursiList = widget.seats.map((e) => '${e.row}${e.number}').toList();
    final qrData = jsonEncode({
      "movie": widget.movie.title,
      "studio": widget.schedule.studioName,
      "seat": kursiList,
      "time": "${widget.time.time.toIso8601String()}",
      "price": widget.price
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Tiket Kamu')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.04),
              Theme.of(context).colorScheme.secondary.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.movie.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    QrImageView(
                      data: qrData,
                      backgroundColor: Colors.white,
                      size: 180,
                    ),
                    const SizedBox(height: 18),
                    Text('${widget.schedule.studioName}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Kursi:', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: [
                              ...widget.seats.map((e) => Chip(
                                    label: Text("${e.row}${e.number}"),
                                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Waktu:  ${widget.time.time.hour.toString().padLeft(2,'0')}:${widget.time.time.minute.toString().padLeft(2,'0')} WIB'),
                    const SizedBox(height: 4),
                    Text('Rp ${widget.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(height: 34),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home_rounded),
                      label: const Text("Kembali ke Beranda"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
