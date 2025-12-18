class Seat {
  final String id;
  final String row;
  final int number;
  final bool isAvailable;
  final bool isSelected;
  final bool isReserved;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.isAvailable,
    this.isSelected = false,
    this.isReserved = false,
  });

  Seat copyWith({
    bool? isAvailable,
    bool? isSelected,
    bool? isReserved,
  }) => Seat(
    id: id,
    row: row,
    number: number,
    isAvailable: isAvailable ?? this.isAvailable,
    isSelected: isSelected ?? this.isSelected,
    isReserved: isReserved ?? this.isReserved,
  );
}


