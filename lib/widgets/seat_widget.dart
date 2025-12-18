import 'package:flutter/material.dart';
import '../domain/entities/seat.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final VoidCallback? onTap;
  final double size;
  const SeatWidget({Key? key, required this.seat, this.onTap, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    if (seat.isReserved) {
      color = Colors.grey[400]!;
    } else if (seat.isSelected) {
      color = Theme.of(context).colorScheme.secondary;
    } else if (seat.isAvailable) {
      color = Colors.green[400]!;
    } else {
      color = Colors.red[300]!;
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: seat.isAvailable && !seat.isReserved ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size * 0.3),
            border: seat.isSelected
                ? Border.all(color: Colors.black, width: 2)
                : null,
            boxShadow: seat.isSelected
                ? [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 7)]
                : [],
          ),
          alignment: Alignment.center,
          child: seat.isReserved
              ? Icon(Icons.event_seat, color: Colors.white, size: size * 0.55)
              : Text(
                  seat.number > 0 ? '${seat.row}${seat.number}' : seat.row,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: size * 0.35, color: Colors.white),
                ),
        ),
      ),
    );
  }
}

