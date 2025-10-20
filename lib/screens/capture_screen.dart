// lib/screens/capture_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../services/ocr_service.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isProcessing = false;
  final OCRService _ocrService = OCRService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(_cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print('Camera init error: $e');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final XFile image = await _controller!.takePicture();
      final note = await _ocrService.processImage(image);
      await _handleNoteResult(note);
    } catch (e) {
      print('takePicture error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickFile() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final note = await _ocrService.pickAndProcessFile();
      await _handleNoteResult(note);
    } catch (e) {
      print('pickFile error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleNoteResult(note) async {
    if (note != null) {
      Provider.of<NoteNotifier>(context, listen: false).addNote(note);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note added successfully!'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to read text. Try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body:
            Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title:
            const Text('Capture Note', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(_controller!)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: _isProcessing ? null : _takePicture,
                  backgroundColor:
                      _isProcessing ? Colors.grey : Colors.tealAccent[400],
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)))
                      : const Icon(Icons.camera_alt, color: Colors.black),
                ),
                FloatingActionButton(
                  heroTag: 'file',
                  onPressed: _isProcessing ? null : _pickFile,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.file_present_rounded,
                      color: Colors.white),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
