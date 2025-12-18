import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';
import 'ticket_page.dart';
import 'dart:async';

class PaymentPage extends StatefulWidget {
  static const String routeName = "/payment";
  final Movie movie;
  final Schedule schedule;
  final ScheduleTime time;
  final List<Seat> seats;
  final int price;
  const PaymentPage({Key? key, required this.movie, required this.schedule, required this.time, required this.seats, required this.price}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool loading = false;
  String selectedPaymentMethod = 'Virtual Card';
  
  final Map<String, IconData> paymentMethods = {
    'Transfer Bank': Icons.account_balance,
    'E-wallet': Icons.account_balance_wallet,
    'Virtual Card': Icons.credit_card_rounded,
  };

  void _bayar() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => loading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TicketPage(
          movie: widget.movie,
          schedule: widget.schedule,
          time: widget.time,
          seats: widget.seats,
          price: widget.price,
        ),
      ),
    );
  }

  void _showPaymentMethodPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...paymentMethods.entries.map((entry) {
                return ListTile(
                  leading: Icon(entry.value, color: Colors.blueAccent),
                  title: Text(entry.key),
                  trailing: selectedPaymentMethod == entry.key
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = entry.key;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')), 
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.payments_rounded, color: Colors.green, size: 60),
            const SizedBox(height: 22),
            const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            const SizedBox(height: 13),
            Card(
              child: InkWell(
                onTap: _showPaymentMethodPicker,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(paymentMethods[selectedPaymentMethod], size: 19, color: Colors.blueAccent),
                          const SizedBox(width: 9),
                          Text(selectedPaymentMethod, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Rp ${widget.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kursi: ', style: TextStyle(fontWeight: FontWeight.w700)),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: [...widget.seats.map((e) => Chip(label: Text("${e.row}${e.number}")))],
                  ),
                ),
              ],
            ),
            const Spacer(),
            loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : _bayar,
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                      child: const Text("Bayar & Dapatkan Tiket", style: TextStyle(fontSize: 18)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
