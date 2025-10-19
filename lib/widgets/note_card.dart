import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note_model.dart';
import '../utils/constants.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2D2D3A), // خلفية الكارت داكنة لتناسق الألوان
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

              // ➡️ أيقونة السهم
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.white38, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
