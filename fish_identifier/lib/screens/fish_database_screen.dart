import 'package:flutter/material.dart';
import '../models/fish.dart';
import '../data/fish_database.dart';
import 'fish_detail_screen.dart';

class FishDatabaseScreen extends StatefulWidget {
  const FishDatabaseScreen({super.key});

  @override
  State<FishDatabaseScreen> createState() => _FishDatabaseScreenState();
}

class _FishDatabaseScreenState extends State<FishDatabaseScreen> {
  final FishDatabase _fishDatabase = FishDatabase();
  final TextEditingController _searchController = TextEditingController();
  
  List<Fish> _allFish = [];
  List<Fish> _filteredFish = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFish();
    _searchController.addListener(_filterFish);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFish() async {
    try {
      final fish = await _fishDatabase.getAllFish();
      setState(() {
        _allFish = fish;
        _filteredFish = fish;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load fish database: $e';
        _isLoading = false;
      });
    }
  }

  void _filterFish() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFish = _allFish;
      } else {
        _filteredFish = _allFish.where((fish) =>
          fish.name.toLowerCase().contains(query) ||
          fish.scientificName.toLowerCase().contains(query) ||
          fish.habitat.toLowerCase().contains(query)
        ).toList();
      }
    });
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
        title: const Text('Fish Database'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green[50],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search fish by name, scientific name, or habitat...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // Results
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
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
              'Loading fish database...',
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
              onPressed: _loadFish,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredFish.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              color: Colors.grey,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No fish found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'The database appears to be empty'
                  : 'Try adjusting your search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredFish.length,
      itemBuilder: (context, index) {
        final fish = _filteredFish[index];
        return _buildFishCard(fish);
      },
    );
  }

  Widget _buildFishCard(Fish fish) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToFishDetail(fish),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Fish icon placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.pets,
                  color: Colors.blue[600],
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Fish information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fish.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fish.scientificName,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fish.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            fish.habitat,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
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
}





