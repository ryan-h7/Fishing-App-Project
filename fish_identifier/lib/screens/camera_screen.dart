import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../services/fish_identification_service.dart';
import 'identification_results_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService _cameraService = CameraService();
  final FishIdentificationService _identificationService = FishIdentificationService();
  
  CameraController? _cameraController;
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (kIsWeb) {
      // Camera not supported on web, show gallery option only
      setState(() {
        _isInitializing = false;
        _error = 'Camera not supported on web. Please use gallery option.';
      });
      return;
    }
    
    try {
      _cameraController = await _cameraService.getCameraController();
      if (_cameraController != null) {
        setState(() {
          _isInitializing = false;
        });
      } else {
        setState(() {
          _error = 'Failed to initialize camera';
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Camera initialization error: $e';
        _isInitializing = false;
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final String? imagePath = await _cameraService.capturePhoto();
      if (imagePath != null) {
        await _identifyFish(imagePath);
      } else {
        _showError('Failed to capture photo');
      }
    } catch (e) {
      _showError('Error capturing photo: $e');
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final String? imagePath = await _cameraService.pickImageFromGallery();
      if (imagePath != null) {
        await _identifyFish(imagePath);
      }
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  Future<void> _identifyFish(String imagePath) async {
    // Save image to app directory
    final String savedPath = await _cameraService.saveImageToAppDirectory(imagePath);
    
    // Navigate to results screen
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentificationResultsScreen(
            imagePath: savedPath,
            identificationService: _identificationService,
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Identify Fish'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              kIsWeb ? 'Camera not available on web' : _error!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              kIsWeb ? 'Please use the gallery option below' : 'Please try again',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!kIsWeb)
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Retry'),
              ),
          ],
        ),
      );
    }

    if (kIsWeb) {
      // Web-friendly interface
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Fish Identification',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select a fish photo from your gallery to identify the species',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Select from Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(
        child: Text(
          'Camera not available',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: CameraPreview(_cameraController!),
        ),
        
        // Overlay with capture button and controls
        Positioned.fill(
          child: Column(
            children: [
              // Top section with instructions
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Point your camera at the fish and tap the capture button',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Spacer to push controls to bottom
              const Spacer(),
              
              // Bottom controls
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery button
                    GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    
                    // Capture button
                    GestureDetector(
                      onTap: _isCapturing ? null : _capturePhoto,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isCapturing ? Colors.grey : Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: _isCapturing
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 3,
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 40,
                              ),
                      ),
                    ),
                    
                    // Placeholder for symmetry
                    const SizedBox(width: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
