import 'package:flutter/material.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/movie.dart';
import '../../widgets/seat_widget.dart';
import '../../services/booking_service.dart';
import 'checkout_page.dart';

class SeatSelectionPage extends StatefulWidget {
  static const String routeName = "/seat";
  final Schedule schedule;
  final ScheduleTime time;
  final Movie movie;
  const SeatSelectionPage({Key? key, required this.schedule,required this.time,required this.movie}) : super(key: key);

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  late List<List<Seat>> seats;
  List<Seat> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _setupSeats();
  }

  void _setupSeats() async {
    // Load reserved seats from BookingService
    final bookingService = BookingService();
    final reservedSeats = await bookingService.getReservedSeats(
      widget.movie.id,
      widget.schedule.id,
      widget.time.timeId,
    );
    
    List<List<Seat>> result = [];
    for (var row = 0; row < 7; row++) {
      String rowChar = String.fromCharCode(65 + row);
      List<Seat> rowSeats = [];
      for (var n = 1; n <= 10; n++) {
        final id = '$rowChar$n';
        final isReserved = reservedSeats.contains(id);
        rowSeats.add(Seat(
          id: id,
          row: rowChar,
          number: n,
          isAvailable: !isReserved,
          isReserved: isReserved,
          isSelected: false,
        ));
      }
      result.add(rowSeats);
    }
    
    setState(() {
      seats = result;
    });
  }

  void selectSeat(Seat seat) {
    setState(() {
      if (!seat.isAvailable || seat.isReserved) return;
      final exists = selectedSeats.any((s) => s.id == seat.id);
      if (exists) {
        selectedSeats.removeWhere((s) => s.id == seat.id);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  bool isSeatSelected(Seat seat) => selectedSeats.any((s) => s.id == seat.id);

  @override
  Widget build(BuildContext context) {
    final isSmallDevice = MediaQuery.of(context).size.height < 660;
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kursi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.schedule.studioName},  ' +
                  '${widget.time.time.hour.toString().padLeft(2, '0')}:${widget.time.time.minute.toString().padLeft(2, '0')} WIB', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 17),
              // Layout kursi grid di box fixed untuk scroll
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxW = constraints.maxWidth.clamp(240.0, 480.0);
                    const double aisleGap = 14; // jarak lorong tengah
                    // 10 kolom kursi + padding + lorong tengah
                    double seatSize = ((maxW - 32 - aisleGap) / 10);
                    seatSize = seatSize.clamp(26.0, 40.0);
                    return Container(
                      width: maxW,
                      constraints: BoxConstraints(
                        maxHeight: isSmallDevice ? 240 : 320,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          // Layar
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            width: maxW * 0.75,
                            height: 13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.grey.withOpacity(.10),
                                  Colors.amber.shade300.withOpacity(0.45),
                                  Colors.grey.withOpacity(.10),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text("LAYAR", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 5, color: Colors.grey[700]),),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: seats.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) {
                                final row = <Widget>[];
                                for (int j = 0; j < seats[i].length; j++) {
                                  // tambah lorong setelah kolom ke-5 (index 4) supaya mirip bioskop
                                  if (j == 5) row.add(SizedBox(width: aisleGap));
                                  row.add(
                                    SeatWidget(
                                      size: seatSize,
                                      seat: seats[i][j].copyWith(isSelected: isSeatSelected(seats[i][j])),
                                      onTap: seats[i][j].isAvailable && !seats[i][j].isReserved 
                                        ? () => selectSeat(seats[i][j]) : null,
                                    ),
                                  );
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: row,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _legendBox(Colors.grey[400]!, 'Terisi'),
                  const SizedBox(width: 10),
                  _legendBox(Colors.green[400]!, 'Tersedia'),
                  const SizedBox(width: 10),
                  _legendBox(Theme.of(context).colorScheme.secondary, 'Dipilih'),
                ],
              ),
              const SizedBox(height: 17),
              if (selectedSeats.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.event_seat_rounded,size:20),
                    const SizedBox(width: 4),
                    Text("Kursi dipilih: ", style: const TextStyle(fontWeight: FontWeight.w700)),
                    ...selectedSeats.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: Chip(label: Text("${e.row}${e.number}")),
                    )),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: const Text("Lanjut ke Checkout"),
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                movie: widget.movie,
                                schedule: widget.schedule,
                                time: widget.time,
                                seats: selectedSeats,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendBox(Color color, String label) => Row(
    children: [
      Container(width: 19, height: 19, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black12))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 13)),
    ],
  );
}
