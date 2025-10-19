import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';

class NoteNotifier extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Note> _notes = [];
  String _searchQuery = '';

  List<Note> get notes => _notes;
  String get searchQuery => _searchQuery;

  NoteNotifier() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _notes = await _storage.loadNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _storage.saveNote(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    await _storage.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<void> updateNote(Note note) async {
    await _storage.updateNote(note);
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Note> get filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    return _notes
        .where((note) =>
            note.text.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  Future<void> refresh() async {
    await _loadNotes();
  }
}
