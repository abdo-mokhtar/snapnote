import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Note? note;
  late TextEditingController _textController;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _titleController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Note?;
      setState(() {
        note = args;
        _textController.text = args?.text ?? '';
        _titleController.text = args?.title ?? '';
      });
    });
  }

  Future<void> _saveNote() async {
    if (note != null) {
      final updatedNote = Note(
        id: note!.id,
        text: _textController.text,
        title: _titleController.text,
        category: note!.category,
        date: note!.date,
      );
      await Provider.of<NoteNotifier>(context, listen: false)
          .updateNote(updatedNote);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _deleteNote() async {
    if (note == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2A),
        title: const Text('Delete Note', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this note?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<NoteNotifier>(context, listen: false)
          .deleteNote(note!.id);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted successfully'),
            backgroundColor: Colors.deepPurpleAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Note Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _deleteNote,
          ),
          IconButton(
            icon:
                const Icon(Icons.save_rounded, color: Colors.deepPurpleAccent),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: note == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter title...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1E1E2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.deepPurpleAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your note here...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: const Color(0xFF1E1E2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.deepPurpleAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D3A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurpleAccent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category: ${note?.category ?? 'Unspecified'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Date: ${note?.date.toString().split(' ')[0] ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}
