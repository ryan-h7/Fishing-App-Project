import 'package:flutter/material.dart';
import '../models/angler.dart';
import '../data/anglers_database.dart';
import 'angler_profile_screen.dart';

class AnglersScreen extends StatefulWidget {
  const AnglersScreen({super.key});

  @override
  State<AnglersScreen> createState() => _AnglersScreenState();
}

class _AnglersScreenState extends State<AnglersScreen> {
  final AnglersDatabase _anglersDatabase = AnglersDatabase();
  final TextEditingController _searchController = TextEditingController();
  
  List<Angler> _allAnglers = [];
  List<Angler> _filteredAnglers = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Online',
    'Experienced (10+ years)',
    'Bass Fishing',
    'Trout Fishing',
    'Saltwater',
    'Fly Fishing',
  ];

  @override
  void initState() {
    super.initState();
    _loadAnglers();
    _searchController.addListener(_filterAnglers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAnglers() async {
    try {
      final anglers = await _anglersDatabase.getAllAnglers();
      setState(() {
        _allAnglers = anglers;
        _filteredAnglers = anglers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load anglers: $e';
        _isLoading = false;
      });
    }
  }

  void _filterAnglers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAnglers = _allAnglers;
      } else {
        _filteredAnglers = _allAnglers.where((angler) =>
          angler.name.toLowerCase().contains(query) ||
          angler.location.toLowerCase().contains(query) ||
          angler.bio.toLowerCase().contains(query) ||
          angler.favoriteFish.any((fish) => fish.toLowerCase().contains(query))
        ).toList();
      }
      _applyFilter();
    });
  }

  void _applyFilter() {
    List<Angler> filtered = _filteredAnglers;
    
    switch (_selectedFilter) {
      case 'Online':
        filtered = filtered.where((angler) => angler.isOnline).toList();
        break;
      case 'Experienced (10+ years)':
        filtered = filtered.where((angler) => angler.experienceYears >= 10).toList();
        break;
      case 'Bass Fishing':
        filtered = filtered.where((angler) => 
          angler.preferredFishingStyle.toLowerCase().contains('bass') ||
          angler.favoriteFish.any((fish) => fish.toLowerCase().contains('bass'))
        ).toList();
        break;
      case 'Trout Fishing':
        filtered = filtered.where((angler) => 
          angler.preferredFishingStyle.toLowerCase().contains('trout') ||
          angler.favoriteFish.any((fish) => fish.toLowerCase().contains('trout'))
        ).toList();
        break;
      case 'Saltwater':
        filtered = filtered.where((angler) => 
          angler.preferredFishingStyle.toLowerCase().contains('saltwater')
        ).toList();
        break;
      case 'Fly Fishing':
        filtered = filtered.where((angler) => 
          angler.preferredFishingStyle.toLowerCase().contains('fly')
        ).toList();
        break;
    }
    
    setState(() {
      _filteredAnglers = filtered;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilter();
  }

  void _navigateToAnglerProfile(Angler angler) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnglerProfileScreen(angler: angler),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect with Anglers'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple[50],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search anglers by name, location, or interests...',
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
          
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.purple[50],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) => _onFilterChanged(filter),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.purple[200],
                      checkmarkColor: Colors.purple[700],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.purple[700] : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
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
              'Loading anglers...',
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
              onPressed: _loadAnglers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredAnglers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              color: Colors.grey,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No anglers found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Try adjusting your filters'
                  : 'Try adjusting your search terms or filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAnglers.length,
      itemBuilder: (context, index) {
        final angler = _filteredAnglers[index];
        return _buildAnglerCard(angler);
      },
    );
  }

  Widget _buildAnglerCard(Angler angler) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToAnglerProfile(angler),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      _getAvatarIcon(angler.avatarIcon),
                      color: Colors.purple[600],
                      size: 30,
                    ),
                  ),
                  if (angler.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // Angler information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            angler.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${angler.experienceYears}y',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
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
                            angler.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      angler.bio,
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
                           Icons.sports_baseball,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            angler.preferredFishingStyle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          '${angler.totalCatches} catches',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: angler.favoriteFish.take(3).map((fish) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            fish,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                            ),
                          ),
                        );
                      }).toList(),
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
