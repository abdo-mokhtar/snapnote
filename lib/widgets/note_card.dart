import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../utils/constants.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2D3A),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            Navigator.pushNamed(context, '/note-detail', arguments: note),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 🟣 دائرة التصنيف
              CircleAvatar(
                radius: 26,
                backgroundColor: primaryColor,
                child: Text(
                  note.category.isNotEmpty
                      ? note.category[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 📝 تفاصيل الملاحظة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.category,
                      style: GoogleFonts.poppins(
                        color: Colors.deepPurpleAccent,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${note.date.day}/${note.date.month}/${note.date.year}',
                      style: GoogleFonts.poppins(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // 🗑️ زر الحذف
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E2A),
                      title: const Text(
                        'Delete Note',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to delete this note?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white54)),
                          onPressed: () => Navigator.pop(ctx, false),
                        ),
                        TextButton(
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.redAccent)),
                          onPressed: () => Navigator.pop(ctx, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    context.read<NoteNotifier>().deleteNote(note.id);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
