import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class StorageService {
  static const String _boxName = 'notesBox';

  Future<List<Note>> loadNotes() async {
    final box = Hive.box<Note>(_boxName);
    return box.values.toList();
  }

  Future<void> saveNote(Note note) async {
    final box = Hive.box<Note>(_boxName);
    await box.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    final box = Hive.box<Note>(_boxName);
    await box.delete(id);
  }

  Future<void> updateNote(Note note) async {
    await saveNote(note);
  }
}
