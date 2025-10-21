import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class StorageService {
  static const String _boxName = 'notesBox';
  static const String _categoryBoxName = 'categoriesBox';

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

  // ✅ New: Manage Categories
  Future<List<String>> loadCategories() async {
    final box = await Hive.openBox<String>(_categoryBoxName);
    return box.values.toList();
  }

  Future<void> addCategory(String category) async {
    final box = await Hive.openBox<String>(_categoryBoxName);
    if (!box.values.contains(category)) {
      await box.add(category);
    }
  }

  Future<void> deleteCategory(String category) async {
    final box = await Hive.openBox<String>(_categoryBoxName);
    final key = box.keys.firstWhere(
      (k) => box.get(k) == category,
      orElse: () => null,
    );
    if (key != null) await box.delete(key);
  }
}
