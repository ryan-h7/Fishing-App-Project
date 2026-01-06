import 'package:flutter/material.dart';
import '../models/fish.dart';
import 'add_catch_screen.dart';

class FishDetailScreen extends StatelessWidget {
  final Fish fish;

  const FishDetailScreen({
    super.key,
    required this.fish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fish.name),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _saveToCatchLog(context),
            icon: const Icon(Icons.bookmark_add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and scientific name
            _buildHeader(),
            
            const SizedBox(height: 24),
            
            // Confidence score
            _buildConfidenceScore(),
            
            const SizedBox(height: 24),
            
            // Description
            _buildDescription(),
            
            const SizedBox(height: 24),
            
            // Characteristics
            _buildCharacteristics(),
            
            const SizedBox(height: 24),
            
            // Habitat information
            _buildHabitatInfo(),
            
            const SizedBox(height: 24),
            
            // Size and weight information
            _buildSizeInfo(),
            
            const SizedBox(height: 24),
            
            // Season information
            _buildSeasonInfo(),
            
            const SizedBox(height: 32),
            
            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fish.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fish.scientificName,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceScore() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green[600], size: 24),
          const SizedBox(width: 12),
          const Text(
            'Identification Confidence:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${(fish.confidence * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return _buildInfoCard(
      title: 'Description',
      icon: Icons.info_outline,
      content: fish.description,
    );
  }

  Widget _buildCharacteristics() {
    return _buildInfoCard(
      title: 'Key Characteristics',
      icon: Icons.list_alt,
      content: fish.characteristics.map((char) => '• $char').join('\n'),
    );
  }

  Widget _buildHabitatInfo() {
    return _buildInfoCard(
      title: 'Habitat',
      icon: Icons.location_on,
      content: fish.habitat,
    );
  }

  Widget _buildSizeInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            title: 'Size',
            icon: Icons.straighten,
            content: fish.size,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            title: 'Weight',
            icon: Icons.fitness_center,
            content: fish.weight,
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonInfo() {
    return _buildInfoCard(
      title: 'Best Season',
      icon: Icons.calendar_today,
      content: fish.season,
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _saveToCatchLog(context),
            icon: const Icon(Icons.bookmark_add),
            label: const Text('Add to Catch Log'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Identify Another Fish'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveToCatchLog(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCatchScreen(
          preSelectedFish: fish,
        ),
      ),
    );
    
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catch saved to your log!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

