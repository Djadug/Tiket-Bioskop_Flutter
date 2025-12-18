import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/seat.dart';
import 'payment_page.dart';

class CheckoutPage extends StatelessWidget {
  static const String routeName = "/checkout";
  final Movie movie;
  final Schedule schedule;
  final ScheduleTime time;
  final List<Seat> seats;
  const CheckoutPage({Key? key, required this.movie, required this.schedule, required this.time, required this.seats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final price = 50000 * seats.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Pesanan')), 
      body: Padding(
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(
                  movie.poster, height: 155, fit: BoxFit.cover,
                  errorBuilder: (ctx,_,__)=>
                    Container(color: Colors.grey[300],height:120,width:100,child:const Icon(Icons.movie)),
                ),
              ),
            ),
            const SizedBox(height: 19),
            Text(movie.title, style: Theme.of(context).textTheme.titleLarge),
            Text('${schedule.studioName}  • ${time.time.hour.toString().padLeft(2,'0')}:${time.time.minute.toString().padLeft(2,'0')} WIB'),
            const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                const Icon(Icons.event_seat),
                const SizedBox(width: 4),
                Text('Kursi: ',style:TextStyle(fontWeight: FontWeight.w700)),
                Expanded(child: Wrap(
                  spacing: 4,
                  children:[
                    ...seats.map((e) => Chip(label: Text("${e.row}${e.number}")))
                  ],
                )),
              ]
            ),
            const SizedBox(height: 12),
            
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Harga',style:TextStyle(fontWeight: FontWeight.w700)),
                Text('Rp $price',style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payments_rounded),
                label: const Text("Bayar Sekarang"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        movie: movie,
                        schedule: schedule,
                        time: time,
                        seats: seats,
                        price: price,
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
    );
  }
}
