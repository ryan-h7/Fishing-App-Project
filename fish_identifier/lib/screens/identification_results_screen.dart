import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/fish.dart';
import '../services/fish_identification_service.dart';
import 'fish_detail_screen.dart';
import 'add_catch_screen.dart';

class IdentificationResultsScreen extends StatefulWidget {
  final String imagePath;
  final FishIdentificationService identificationService;

  const IdentificationResultsScreen({
    super.key,
    required this.imagePath,
    required this.identificationService,
  });

  @override
  State<IdentificationResultsScreen> createState() => _IdentificationResultsScreenState();
}

class _IdentificationResultsScreenState extends State<IdentificationResultsScreen> {
  FishIdentificationResult? _result;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _identifyFish();
  }

  Future<void> _identifyFish() async {
    try {
      final result = await widget.identificationService.identifyFish(widget.imagePath);
      setState(() {
        _result = result;
        _isLoading = false;
        if (result.hasError) {
          _error = result.error;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to identify fish: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToFishDetail(Fish fish) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FishDetailScreen(fish: fish),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Identifying fish...',
              style: TextStyle(fontSize: 16),
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
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _identifyFish();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_result == null) {
      return const Center(
        child: Text('No results available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Captured image
          _buildImageSection(),
          
          const SizedBox(height: 24),
          
          // Primary identification result
          if (_result!.identifiedFish != null) ...[
            _buildPrimaryResult(_result!.identifiedFish!),
            const SizedBox(height: 24),
          ],
          
          // Possible matches
          if (_result!.possibleMatches.isNotEmpty) ...[
            _buildPossibleMatches(),
            const SizedBox(height: 24),
          ],
          
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      // For web, show a placeholder since we can't display local files
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            const Text(
              'Captured Image',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Image captured successfully',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      // For mobile/desktop, use Image.file
      return Image.file(
        File(widget.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildPrimaryResult(Fish fish) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600]),
              const SizedBox(width: 8),
              Text(
                'Identified Fish',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(fish.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fish.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            fish.scientificName,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fish.description,
            style: const TextStyle(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToFishDetail(fish),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPossibleMatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other Possible Matches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...(_result!.possibleMatches.map((fish) => _buildPossibleMatchCard(fish))),
      ],
    );
  }

  Widget _buildPossibleMatchCard(Fish fish) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fish.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  fish.scientificName,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${(fish.confidence * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _navigateToFishDetail(fish),
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Another Photo'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _result!.identifiedFish != null
                    ? () => _navigateToFishDetail(_result!.identifiedFish!)
                    : null,
                icon: const Icon(Icons.info_outline),
                label: const Text('View Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _result!.identifiedFish != null
                ? () => _saveToCatchLog(_result!.identifiedFish!)
                : null,
            icon: const Icon(Icons.bookmark_add),
            label: const Text('Save to Catch Log'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveToCatchLog(Fish fish) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCatchScreen(
          preSelectedFish: fish,
          photoPath: widget.imagePath,
        ),
      ),
    );
    
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catch saved to your log!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
