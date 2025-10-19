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

    // ✅ تأجيل استخدام context بعد أول build
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملاحظة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: note == null
            ? const Center(child: CircularProgressIndicator()) // أثناء التحميل
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'العنوان',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelText: 'النص',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Text('التصنيف: ${note?.category ?? 'غير محدد'}'),
                  Text('التاريخ: ${note?.date.toString().split(' ')[0] ?? ''}'),
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
