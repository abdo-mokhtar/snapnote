import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:snapnote/screens/capture_screen.dart';
import 'package:snapnote/screens/categories_screen.dart' show CategoriesScreen;
import 'package:snapnote/screens/note_detail_screen.dart' show NoteDetailScreen;
import 'providers/note_provider.dart'; // استيراد الـNotifier
import 'screens/home_screen.dart';
import 'models/note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Provider رئيسي
      create: (context) => NoteNotifier(),
      child: MaterialApp(
        title: 'SnapNote',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          fontFamily: GoogleFonts.roboto().fontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xFF2196F3),
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: const HomeScreen(),
        routes: {
          '/capture': (context) => const CaptureScreen(),
          '/note-detail': (context) => const NoteDetailScreen(),
          '/categories': (context) => const CategoriesScreen(),
        },
      ),
    );
  }
}
