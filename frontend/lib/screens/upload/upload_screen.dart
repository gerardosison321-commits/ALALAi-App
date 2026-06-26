import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/api_service.dart';
import '../../core/routes/app_routes.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isUploading = false;
  String? _extractedText;
  File? _selectedFile;

  /// Pick PDF using file_picker
  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _extractedText = null;
      });
    }
  }

  /// Take photo using camera
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedFile = File(photo.path);
        _extractedText = null;
      });
    }
  }

  /// Pick image from gallery
  Future<void> _pickGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        _extractedText = null;
      });
    }
  }

  /// Upload file to backend, extract text, then create session
  Future<void> _uploadAndContinue() async {
    if (_selectedFile == null) {
      _showSnack('Please select a file first');
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Step 1: Upload file → get extracted text
      final extracted = await ApiService.uploadFile(_selectedFile!);
      setState(() => _extractedText = extracted);

      // Step 2: Create session with extracted content
      // You need to pass gradeLevel, subject, language from user prefs
      // For now, using defaults — replace with actual user selections
      final sessionData = await ApiService.createSession(
        gradeLevel: 7,           // TODO: get from user prefs
        subject: 'science',      // TODO: get from user prefs or auto-detect
        language: 'mixed',       // TODO: get from user prefs
        content: extracted,
      );

      final sessionId = sessionData['session']['id'] as String;

      if (!mounted) return;
      _showSnack('Session created! Loading cards...');

      // Step 3: Navigate to swipe screen with session ID
      Navigator.pushNamed(
        context,
        AppRoutes.swipe,
        arguments: {'sessionId': sessionId},
      );
    } on ApiException catch (e) {
      _showSnack('Error: ${e.message}');
    } catch (e) {
      _showSnack('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(title: const Text('Upload Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // File preview area
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.deepPurple.shade100,
                  width: 2,
                ),
              ),
              child: _selectedFile != null
                  ? _buildFilePreview()
                  : _buildEmptyPreview(),
            ),

            const SizedBox(height: 30),

            // Buttons
            _buildButton(
              icon: Icons.picture_as_pdf,
              label: 'Choose PDF',
              onPressed: _isUploading ? null : _pickPdf,
            ),
            const SizedBox(height: 14),
            _buildButton(
              icon: Icons.camera_alt,
              label: 'Take Photo',
              onPressed: _isUploading ? null : _takePhoto,
            ),
            const SizedBox(height: 14),
            _buildButton(
              icon: Icons.photo_library,
              label: 'Choose from Gallery',
              onPressed: _isUploading ? null : _pickGallery,
            ),

            const Spacer(),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: FilledButton(
                onPressed: _isUploading ? null : _uploadAndContinue,
                child: _isUploading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload,
          size: 70,
          color: Colors.deepPurple.shade300,
        ),
        const SizedBox(height: 20),
        const Text(
          'Upload your lesson',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'PDF • Image • Worksheet',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFilePreview() {
    final isImage = _selectedFile!.path.endsWith('.jpg') ||
        _selectedFile!.path.endsWith('.jpeg') ||
        _selectedFile!.path.endsWith('.png');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedFile!,
              height: 140,
              fit: BoxFit.cover,
            ),
          )
        else
          Icon(
            Icons.picture_as_pdf,
            size: 70,
            color: Colors.red.shade400,
          ),
        const SizedBox(height: 12),
        Text(
          _selectedFile!.path.split('/').last,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (_extractedText != null) ...[
          const SizedBox(height: 8),
          const Text(
            '✅ Text extracted successfully',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade50,
          foregroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
