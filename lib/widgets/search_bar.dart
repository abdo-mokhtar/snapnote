import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteNotifier>(
      builder: (context, noteNotifier, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => noteNotifier.setSearchQuery(value),
            decoration: InputDecoration(
              hintText: 'ابحث في ملاحظاتك...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => noteNotifier.setSearchQuery(''),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        );
      },
    );
  }
}
