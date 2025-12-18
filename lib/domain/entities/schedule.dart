class Schedule {
  final String id;
  final String movieId;
  final DateTime date;
  final List<ScheduleTime> timeslots;
  final String studioName;

  Schedule({
    required this.id,
    required this.movieId,
    required this.date,
    required this.timeslots,
    required this.studioName,
  });
}

class ScheduleTime {
  final String timeId;
  final DateTime time;
  ScheduleTime({required this.timeId, required this.time});
}


