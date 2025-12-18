import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  static const String routeName = "/history";
  const HistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Dummy kosong, diimplementasikan provider ticket di real app
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Tiket')),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 66, color: Colors.grey[400]),
          const SizedBox(height: 13),
          const Text('Belum ada riwayat transaksi tiket.', style: TextStyle(fontSize: 16)),
        ],
      )),
    );
  }
}
