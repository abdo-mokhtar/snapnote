import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<NoteNotifier>(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/capture'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2A),
          border: Border(
            top: BorderSide(color: Colors.deepPurpleAccent, width: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.white60,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_rounded), label: 'Capture'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_rounded), label: 'Categories'),
          ],
          onTap: (index) {
            if (index == 1) Navigator.pushNamed(context, '/capture');
            if (index == 2) Navigator.pushNamed(context, '/categories');
          },
        ),
      ),
    );
  }
}
