import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../services/booking_service.dart';
import '../../domain/entities/booking.dart';
import 'dart:convert';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({Key? key}) : super(key: key);

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  List<Booking> tickets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    final bookingService = BookingService();
    final myTickets = await bookingService.getMyTickets();
    setState(() {
      tickets = myTickets.reversed.toList(); // Latest first
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Saya'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Belum ada tiket', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Text('Pesan tiket film favoritmu sekarang!', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(ticket);
                  },
                ),
    );
  }

  Widget _buildTicketCard(Booking ticket) {
    final kursiList = ticket.seats.map((e) => '${e.row}${e.number}').toList();
    final qrData = jsonEncode({
      "movie": ticket.movie.title,
      "studio": ticket.schedule.studioName,
      "seat": kursiList,
      "time": "${ticket.time.time.toIso8601String()}",
      "price": ticket.price
    });

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      ticket.movie.poster,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => const Icon(Icons.movie, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.movie.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.schedule.studioName,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ticket.time.time.hour.toString().padLeft(2, '0')}:${ticket.time.time.minute.toString().padLeft(2, '0')} WIB',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.event_seat, size: 18, color: Colors.blueAccent),
                const SizedBox(width: 6),
                const Text('Kursi: ', style: TextStyle(fontWeight: FontWeight.w600)),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: ticket.seats.map((e) => Chip(
                      label: Text('${e.row}${e.number}', style: const TextStyle(fontSize: 12)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rp ${ticket.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () => _showQRDialog(qrData, ticket),
                  icon: const Icon(Icons.qr_code, size: 18),
                  label: const Text('Lihat QR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQRDialog(String qrData, Booking ticket) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.movie.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: qrData,
                backgroundColor: Colors.white,
                size: 200,
              ),
              const SizedBox(height: 16),
              Text('${ticket.schedule.studioName}'),
              Text('${ticket.time.time.hour.toString().padLeft(2, '0')}:${ticket.time.time.minute.toString().padLeft(2, '0')} WIB'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
