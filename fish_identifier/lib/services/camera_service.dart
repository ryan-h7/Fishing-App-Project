import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  final ImagePicker _imagePicker = ImagePicker();
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  Future<void> initialize() async {
    _cameras = await availableCameras();
  }

  Future<CameraController?> getCameraController() async {
    if (_cameras == null || _cameras!.isEmpty) {
      await initialize();
    }

    if (_cameras == null || _cameras!.isEmpty) {
      return null;
    }

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    return _cameraController;
  }

  Future<String?> capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return null;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      return photo.path;
    } catch (e) {
      print('Error capturing photo: $e');
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<String?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  Future<String> saveImageToAppDirectory(String imagePath) async {
    if (kIsWeb) {
      // For web, just return the original path since we can't save to local directory
      return imagePath;
    }
    
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'fish_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = path.join(appDir.path, 'fish_images', fileName);
      
      // Create directory if it doesn't exist
      final Directory fishImagesDir = Directory(path.dirname(newPath));
      if (!await fishImagesDir.exists()) {
        await fishImagesDir.create(recursive: true);
      }

      // Copy the image to the new location
      final File originalFile = File(imagePath);
      await originalFile.copy(newPath);
      
      return newPath;
    } catch (e) {
      print('Error saving image: $e');
      return imagePath; // Return original path if saving fails
    }
  }

  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
  }

  bool get isInitialized => _cameraController?.value.isInitialized ?? false;
}
