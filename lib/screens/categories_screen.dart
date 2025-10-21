import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    return Container(
      color: const Color(0xFF121212),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟣 عنوان الصفحة
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              'My Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // 🟢 القائمة
          Expanded(
            child: Consumer<NoteNotifier>(
              builder: (context, noteNotifier, child) {
                final categories = noteNotifier.categories;

                if (categories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories yet.\nTap + to create one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final notes =
                        noteNotifier.getNotesByCategory(category).length;

                    return GestureDetector(
                      onTap: () {
                        // فتح التفاصيل أو عرض الملاحظات الخاصة بالفئة
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: const Color(0xFF1E1E2A),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          builder: (context) {
                            final categoryNotes =
                                noteNotifier.getNotesByCategory(category);

                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          noteNotifier.deleteCategory(category);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                  const Divider(color: Colors.white24),
                                  const SizedBox(height: 8),
                                  if (categoryNotes.isEmpty)
                                    const Text(
                                      'No notes yet.',
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 14),
                                    )
                                  else
                                    ...categoryNotes
                                        .map((note) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              child: NoteCard(note: note),
                                            ))
                                        .toList(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.deepPurpleAccent.withOpacity(0.6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  Colors.deepPurpleAccent.withOpacity(0.2),
                              child: Text(
                                category[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$notes notes',
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🟣 زر الإضافة
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFF1E1E2A),
                    title: const Text(
                      'Add Category',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: TextField(
                      controller: categoryController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter category name',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      TextButton(
                        onPressed: () {
                          final category = categoryController.text.trim();
                          if (category.isNotEmpty) {
                            Provider.of<NoteNotifier>(context, listen: false)
                                .addCategory(category);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
              backgroundColor: Colors.deepPurpleAccent,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
