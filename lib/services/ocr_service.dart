// lib/services/ocr_service.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

class OCRService {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  /// Process an image file (camera or image file)
  Future<Note?> processImage(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.trim().isEmpty) return null;

      final lines = recognizedText.text.split('\n');
      final firstLine = lines.isNotEmpty ? lines.first.trim() : '';
      final title = firstLine.isNotEmpty
          ? (firstLine.length > 50 ? firstLine.substring(0, 50) : firstLine)
          : 'Untitled';

      final note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: recognizedText.text.trim(),
        title: title,
        category: 'General',
        date: DateTime.now(),
      );
      return note;
    } catch (e) {
      print('OCR Error (processImage): $e');
      return null;
    }
  }

  /// Pick either an image or a PDF from device and process it.
  Future<Note?> pickAndProcessFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result == null || result.files.isEmpty) return null;
      final path = result.files.single.path;
      if (path == null) return null;

      if (path.toLowerCase().endsWith('.pdf')) {
        // Convert first page (or all pages) of PDF to image(s), then OCR
        return await _processPdfAsImage(path);
      } else {
        // It's an image file
        final xfile = XFile(path);
        return await processImage(xfile);
      }
    } catch (e) {
      print('pickAndProcessFile error: $e');
      return null;
    }
  }

  /// Render first page(s) of PDF to image file(s) and OCR them.
  Future<Note?> _processPdfAsImage(String pdfPath) async {
    try {
      final doc = await PdfDocument.openFile(pdfPath);

      // We'll render only the first page to keep it fast. To render all pages,
      // loop i from 1..doc.pagesCount and concatenate results.
      final page = await doc.getPage(1);

      // Render the page to an image (you can pass width/height if needed)
      final pageImage =
          await page.render(width: 1080, height: 1920); // returns PdfPageImage?
      if (pageImage == null) {
        await page.close();
        await doc.close();
        return null;
      }

      // Get a temp directory and write the bytes as a PNG file
      final tempDir = await getTemporaryDirectory();
      final imgFile = File(
          '${tempDir.path}/pdf_page_${DateTime.now().millisecondsSinceEpoch}.png');
      await imgFile.writeAsBytes(pageImage.bytes);

      await page.close();
      await doc.close();

      // Now run OCR on the generated image file
      final xfile = XFile(imgFile.path);
      final note = await processImage(xfile);

      // Optionally delete temp image file (keep if you want)
      try {
        await imgFile.delete();
      } catch (_) {}

      return note;
    } catch (e) {
      print('PDF processing error (_processPdfAsImage): $e');
      return null;
    }
  }

  /// Call when you want to dispose the recognizer
  void dispose() {
    _textRecognizer.close();
  }
}
