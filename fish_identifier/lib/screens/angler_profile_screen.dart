import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/angler.dart';

class AnglerProfileScreen extends StatelessWidget {
  final Angler angler;

  const AnglerProfileScreen({
    super.key,
    required this.angler,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(angler.name),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _connectWithAngler(context),
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and basic info
            _buildHeader(),
            
            const SizedBox(height: 24),
            
            // Online status and last active
            _buildStatusInfo(),
            
            const SizedBox(height: 24),
            
            // Bio
            _buildBio(),
            
            const SizedBox(height: 24),
            
            // Statistics
            _buildStatistics(),
            
            const SizedBox(height: 24),
            
            // Favorite fish
            _buildFavoriteFish(),
            
            const SizedBox(height: 24),
            
            // Fishing style and spots
            _buildFishingInfo(),
            
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
          colors: [Colors.purple[600]!, Colors.purple[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  _getAvatarIcon(angler.avatarIcon),
                  color: Colors.white,
                  size: 40,
                ),
              ),
              if (angler.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Name and location
          Text(
            angler.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                angler.location,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: angler.isOnline ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: angler.isOnline ? Colors.green[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            angler.isOnline ? Icons.circle : Icons.circle_outlined,
            color: angler.isOnline ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            angler.isOnline ? 'Online now' : 'Last active ${_formatLastActive()}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: angler.isOnline ? Colors.green[700] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio() {
    return _buildInfoCard(
      title: 'About',
      icon: Icons.info_outline,
      content: angler.bio,
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Experience',
            '${angler.experienceYears} years',
            Icons.schedule,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Catches',
            '${angler.totalCatches}',
            Icons.sports_baseball,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteFish() {
    return _buildInfoCard(
      title: 'Favorite Fish',
      icon: Icons.pets,
      content: angler.favoriteFish.map((fish) => '• $fish').join('\n'),
    );
  }

  Widget _buildFishingInfo() {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Fishing Style',
          icon: Icons.sports_baseball,
          content: angler.preferredFishingStyle,
        ),
        const SizedBox(height: 16),
        if (angler.fishingSpots.isNotEmpty)
          _buildInfoCard(
            title: 'Favorite Spots',
            icon: Icons.location_on,
            content: angler.fishingSpots.map((spot) => '• $spot').join('\n'),
          ),
      ],
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
              Icon(icon, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
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
            onPressed: () => _connectWithAngler(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Connect'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
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
              // TODO: Implement message functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Messaging feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.message),
            label: const Text('Send Message'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _connectWithAngler(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect with ${angler.name}'),
        content: Text('Send a connection request to ${angler.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connection request sent to ${angler.name}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  String _formatLastActive() {
    final now = DateTime.now();
    final difference = now.difference(angler.lastActive);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(angler.lastActive);
    }
  }

  IconData _getAvatarIcon(String iconName) {
    switch (iconName) {
      case 'fishing_rod':
        return Icons.sports_baseball;
      case 'nature_people':
        return Icons.nature_people;
      case 'sports_baseball':
        return Icons.sports_baseball;
      case 'waves':
        return Icons.waves;
      case 'landscape':
        return Icons.landscape;
      case 'eco':
        return Icons.eco;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'kayaking':
        return Icons.kayaking;
      default:
        return Icons.person;
    }
  }
}
