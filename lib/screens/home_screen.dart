import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapNote',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                Provider.of<NoteNotifier>(context, listen: false).refresh(),
          ),
        ],
      ),
      body: Consumer<NoteNotifier>(
        // Consumer لمراقبة التغييرات
        builder: (context, noteNotifier, child) {
          final filteredNotes = noteNotifier.filteredNotes;
          return Column(
            children: [
              SearchBar(), // هيستخدم Provider داخلها
              Expanded(
                child: filteredNotes.isEmpty
                    ? const Center(child: Text('لا توجد ملاحظات'))
                    : ListView.builder(
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) =>
                            NoteCard(note: filteredNotes[index]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/capture'),
        backgroundColor: const Color(0xFF03DAC6),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'تصوير'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'تصنيفات'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/capture');
          if (index == 2) Navigator.pushNamed(context, '/categories');
        },
      ),
    );
  }
}
