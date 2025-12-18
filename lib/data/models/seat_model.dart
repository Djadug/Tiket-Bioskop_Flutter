import '../../domain/entities/seat.dart';

class SeatModel extends Seat {
  SeatModel({
    required super.id,
    required super.row,
    required super.number,
    required super.isAvailable,
    super.isSelected = false,
    super.isReserved = false,
  });
  
  factory SeatModel.fromJson(Map<String, dynamic> json) => SeatModel(
    id: json['id'],
    row: json['row'],
    number: json['number'],
    isAvailable: json['isAvailable'],
    isSelected: json['isSelected'] ?? false,
    isReserved: json['isReserved'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'row': row,
    'number': number,
    'isAvailable': isAvailable,
    'isSelected': isSelected,
    'isReserved': isReserved,
  };
}


