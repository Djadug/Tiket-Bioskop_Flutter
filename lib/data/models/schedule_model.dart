import '../../domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  ScheduleModel({
    required super.id,
    required super.movieId,
    required super.date,
    required super.timeslots,
    required super.studioName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'],
    movieId: json['movieId'],
    date: DateTime.parse(json['date']),
    timeslots: (json['timeslots'] as List)
        .map((e) => ScheduleTimeModel.fromJson(e)).toList(),
    studioName: json['studioName'],
  );
}

class ScheduleTimeModel extends ScheduleTime {
  ScheduleTimeModel({required super.timeId, required super.time});
  factory ScheduleTimeModel.fromJson(Map<String, dynamic> json) =>
      ScheduleTimeModel(
          timeId: json['timeId'], time: DateTime.parse(json['time']));
}


