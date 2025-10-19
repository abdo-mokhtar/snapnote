import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../utils/constants.dart';
import '../widgets/note_card.dart'; // إضافة: استيراد categories

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التصنيفات')),
      body: Consumer<NoteNotifier>(
        builder: (context, noteNotifier, child) {
          return ListView.builder(
            itemCount: categories.length, // دلوقتي categories معرّفة
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryNotes = noteNotifier.getNotesByCategory(category);
              return ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF2196F3),
                  child: Text(category[0]),
                ),
                title: Text(category),
                children: [
                  if (categoryNotes.isEmpty)
                    const ListTile(title: Text('لا توجد ملاحظات'))
                  else
                    ...categoryNotes.map((note) =>
                        NoteCard(note: note)), // دلوقتي NoteCard معرّف
                ],
              );
            },
          );
        },
      ),
    );
  }
}
