import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'fish_database_screen.dart';
import 'catch_log_screen.dart';
import 'anglers_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish Identifier'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                _buildWelcomeSection(),
                
                const SizedBox(height: 32),
                
                // Main action buttons
                _buildMainActions(context),
                
                const SizedBox(height: 32),
                
                // Quick stats or tips
                _buildQuickTips(),
                
                const SizedBox(height: 24), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Fish Identifier',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Identify fish species, track your catches, and connect with fellow anglers.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildMainActions(BuildContext context) {
    return Column(
      children: [
        // Primary action - Identify Fish
        _buildActionCard(
          context: context,
          title: 'Identify Fish',
          subtitle: 'Take a photo to identify fish species',
          icon: Icons.camera_alt,
          color: Colors.blue[600]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Secondary action - Browse Fish Database
        _buildActionCard(
          context: context,
          title: 'Browse Fish Database',
          subtitle: 'Explore different fish species and their characteristics',
          icon: Icons.library_books,
          color: Colors.green[600]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FishDatabaseScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Catch Log feature
        _buildActionCard(
          context: context,
          title: 'Catch Log',
          subtitle: 'View your fishing history and statistics',
          icon: Icons.history,
          color: Colors.orange[600]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CatchLogScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        _buildActionCard(
          context: context,
          title: 'Connect with Anglers',
          subtitle: 'Find fishing buddies in your area',
          icon: Icons.people,
          color: Colors.purple[600]!,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnglersScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Take clear, well-lit photos of the fish\n'
            '• Include the fish\'s side profile for best results\n'
            '• Make sure the fish fills most of the frame\n'
            '• Avoid blurry or dark images',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
