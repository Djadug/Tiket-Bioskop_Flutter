import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../../services/admin_service.dart';
import '../../../domain/entities/movie_config.dart';

class AdminMovieFormPage extends StatefulWidget {
  final MovieConfig? movieConfig; // null for add
  final int slotIndex; // index in the 5‑slot list
  final List<MovieConfig> allMovies; // for conflict checks
  const AdminMovieFormPage({
    Key? key,
    this.movieConfig,
    required this.slotIndex,
    required this.allMovies,
  }) : super(key: key);

  @override
  State<AdminMovieFormPage> createState() => _AdminMovieFormPageState();
}

class _AdminMovieFormPageState extends State<AdminMovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _durationController = TextEditingController();
  final _genresController = TextEditingController();
  int? _studioId;
  List<String> _showtimes = [];
  String? _posterBase64; // base64 string or asset path

  @override
  void initState() {
    super.initState();
    if (widget.movieConfig != null) {
      final m = widget.movieConfig!;
      _titleController.text = m.title;
      _synopsisController.text = m.synopsis;
      _durationController.text = m.duration.toString();
      _genresController.text = m.genres.join(', ');
      _studioId = m.studioId;
      _showtimes = List.from(m.showtimes);
      _posterBase64 = m.posterBase64;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _posterBase64 = 'data:image/png;base64,' + base64Encode(bytes);
      });
    }
  }

  void _addShowtime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final formatted = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      if (!_showtimes.contains(formatted)) {
        setState(() {
          _showtimes.add(formatted);
        });
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih studio')));
      return;
    }
    if (_showtimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambahkan setidaknya satu jam tayang')));
      return;
    }
    final genres = _genresController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final newConfig = MovieConfig(
      id: widget.movieConfig?.id ?? 'm${widget.slotIndex + 1}',
      title: _titleController.text.trim(),
      posterBase64: _posterBase64 ?? 'assets/images/placeholder.jpg',
      synopsis: _synopsisController.text.trim(),
      duration: int.parse(_durationController.text.trim()),
      genres: genres,
      studioId: _studioId!,
      showtimes: _showtimes,
      lastUpdated: DateTime.now(),
    );

    // Conflict detection using AdminService helper
    final adminService = AdminService();
    final conflict = adminService.hasScheduleConflict(
      newConfig.studioId,
      newConfig.showtimes,
      widget.allMovies,
      excludeMovieId: newConfig.id,
    );
    if (conflict) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jadwal konflik dengan film lain')));
      return;
    }

    // Replace or add in the list
    final updatedList = List<MovieConfig>.from(widget.allMovies);
    if (widget.movieConfig != null) {
      final idx = updatedList.indexWhere((c) => c.id == newConfig.id);
      if (idx >= 0) updatedList[idx] = newConfig;
    } else {
      // Adding new – ensure we don't exceed 5 slots
      if (updatedList.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat menambah lebih dari 5 film')));
        return;
      }
      updatedList.add(newConfig);
    }
    await adminService.saveMovieConfigs(updatedList);
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    _durationController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.movieConfig != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Film' : 'Tambah Film')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _posterBase64 == null
                      ? const Icon(Icons.add_a_photo, size: 80)
                      : _buildPosterImage(_posterBase64!),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) => (v == null || v.isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _synopsisController,
                decoration: const InputDecoration(labelText: 'Sinopsis'),
                maxLines: 3,
                validator: (v) => (v == null || v.isEmpty) ? 'Sinopsis wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Durasi (menit)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Durasi wajib diisi';
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return 'Durasi harus angka positif';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genresController,
                decoration: const InputDecoration(labelText: 'Genre (pisah koma)'),
                validator: (v) => (v == null || v.isEmpty) ? 'Genre wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              // Studio dropdown
              DropdownButtonFormField<int>(
                value: _studioId,
                items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('Studio ${i + 1}'))),
                decoration: const InputDecoration(labelText: 'Studio'),
                onChanged: (v) => setState(() => _studioId = v),
                validator: (v) => v == null ? 'Pilih studio' : null,
              ),
              const SizedBox(height: 12),
              // Showtimes list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jam Tayang'),
                  TextButton.icon(
                    onPressed: _addShowtime,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: _showtimes
                    .map((t) => Chip(
                          label: Text(t),
                          onDeleted: () => setState(() => _showtimes.remove(t)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Film'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPosterImage(String data) {
    if (data.startsWith('data:image') || data.contains('base64')) {
      try {
        final base64String = data.contains(',') ? data.split(',')[1] : data;
        return Image.memory(
          base64Decode(base64String),
          width: 200, // Reasonable preview size
          height: 300,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return const Icon(Icons.error, color: Colors.red, size: 80);
      }
    } else if (data.startsWith('assets/')) {
      return Image.asset(
        data,
        width: 200,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 80);
        },
      );
    } else {
      // Fallback or file path if we were supporting local files
      return const Icon(Icons.image_not_supported, size: 80);
    }
  }
}
