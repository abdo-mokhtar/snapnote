import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/note_model.dart';

class OCRService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<Note?> processImage(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isEmpty) return null;

      // إصلاح: استخراج أول 50 حرف من السطر الأول
      final lines = recognizedText.text.split('\n');
      final firstLine = lines.isNotEmpty ? lines.first : '';
      final title =
          firstLine.length > 50 ? firstLine.substring(0, 50) : firstLine;

      String category = 'عام'; // افتراضي، يمكن تحسينه بـML لاحقًا

      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID بسيط
        text: recognizedText.text,
        title: title,
        category: category,
        date: DateTime.now(),
      );

      await _textRecognizer.close();
      return note;
    } catch (e) {
      print('خطأ في OCR: $e');
      return null;
    }
  }
}
