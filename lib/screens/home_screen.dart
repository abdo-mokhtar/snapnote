import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'capture_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildNotesView(context), // index 0
      const CaptureScreen(), // index 1
      const CategoriesScreen(), // index 2
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SnapNote',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      ),

      // ✅ body يعتمد على الصفحة المختارة
      body: screens[_pageIndex],

      // ✅ curved navigation bar
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF1E1E2A),
        buttonBackgroundColor: Colors.deepPurpleAccent,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.home_rounded, size: 28, color: Colors.white),
          Icon(Icons.camera_alt_rounded, size: 28, color: Colors.white),
          Icon(Icons.category_rounded, size: 28, color: Colors.white),
        ],
        onTap: (index) {
          setState(() => _pageIndex = index);
        },
      ),
    );
  }

  /// 🟣 Widget: قائمة الملاحظات
  Widget _buildNotesView(BuildContext context) {
    return Consumer<NoteNotifier>(
      builder: (context, noteNotifier, child) {
        final filteredNotes = noteNotifier.filteredNotes;

        if (filteredNotes.isEmpty) {
          return const Center(
            child: Text(
              'No notes found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white60,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/detail', arguments: note),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E2A),
                      title: const Text('Delete Note',
                          style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'Are you sure you want to delete this note?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white70)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await Provider.of<NoteNotifier>(context, listen: false)
                        .deleteNote(note.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Note deleted'),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: NoteCard(note: note),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
