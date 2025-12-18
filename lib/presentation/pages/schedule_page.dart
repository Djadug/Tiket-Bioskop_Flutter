import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/schedule.dart';
import 'seat_selection_page.dart';

class SchedulePage extends StatefulWidget {
  static const String routeName = "/schedule";
  final Movie movie;
  const SchedulePage({Key? key, required this.movie}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Schedule> schedules = [];
  int? selectedScheduleIdx;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }
  Future<void> _loadSchedule() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Smart scheduling: assign unique studio and times per movie
    // This ensures no two movies have the same studio at the same time
    
    final studios = ['Studio 1', 'Studio 2', 'Studio 3', 'Studio 4', 'Studio 5'];
    final movieIndex = int.tryParse(widget.movie.id.replaceAll('m', '')) ?? 1;
    
    // Assign studio based on movie index (rotating)
    final studioIndex = (movieIndex - 1) % studios.length;
    final studioName = studios[studioIndex];
    
    // Base time varies by movie to avoid conflicts
    // Movie 1: 10:00, 13:00, 16:00, 19:00
    // Movie 2: 11:00, 14:00, 17:00, 20:00
    // Movie 3: 12:00, 15:00, 18:00, 21:00
    // Movie 4: 10:30, 13:30, 16:30, 19:30
    // Movie 5: 11:30, 14:30, 17:30, 20:30
    
    final baseHours = [10, 11, 12, 10, 11];
    final baseMinutes = [0, 0, 0, 30, 30];
    
    final baseHour = baseHours[(movieIndex - 1) % baseHours.length];
    final baseMinute = baseMinutes[(movieIndex - 1) % baseMinutes.length];
    
    final now = DateTime.now();
    
    setState(() {
      schedules = [
        Schedule(
          id: 's_${widget.movie.id}_1',
          movieId: widget.movie.id,
          date: now,
          timeslots: [
            ScheduleTime(
              timeId: 'st_${widget.movie.id}_1',
              time: DateTime(now.year, now.month, now.day, baseHour, baseMinute),
            ),
            ScheduleTime(
              timeId: 'st_${widget.movie.id}_2',
              time: DateTime(now.year, now.month, now.day, baseHour + 3, baseMinute),
            ),
            ScheduleTime(
              timeId: 'st_${widget.movie.id}_3',
              time: DateTime(now.year, now.month, now.day, baseHour + 6, baseMinute),
            ),
            ScheduleTime(
              timeId: 'st_${widget.movie.id}_4',
              time: DateTime(now.year, now.month, now.day, baseHour + 9, baseMinute),
            ),
          ],
          studioName: studioName,
        ),
      ];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Jadwal ${widget.movie.title}")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...schedules.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final schedule = entry.value;
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${schedule.studioName} (" +
                              "${schedule.date.day}/${schedule.date.month}/${schedule.date.year})",
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 13,
                            children: schedule.timeslots.asMap().entries.map((tSlotEntry) {
                              final tIdx = tSlotEntry.key;
                              final timeslot = tSlotEntry.value;
                              final isSelected = selectedScheduleIdx == idx*10 + tIdx;
                              return ChoiceChip(
                                selected: isSelected,
                                label: Text("${timeslot.time.hour.toString().padLeft(2,'0')}:${timeslot.time.minute.toString().padLeft(2,'0')}",
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                onSelected: (v) {
                                  setState(() {
                                    selectedScheduleIdx = idx*10 + tIdx;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: selectedScheduleIdx == null ? null : () {
                    final idx = selectedScheduleIdx! ~/ 10;
                    final tIdx = selectedScheduleIdx! % 10;
                    final selected = schedules[idx];
                    final slot = selected.timeslots[tIdx];
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SeatSelectionPage(schedule: selected, time: slot, movie: widget.movie),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
                  child: const Text("Lanjut Pilih Kursi", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
    );
  }
}
