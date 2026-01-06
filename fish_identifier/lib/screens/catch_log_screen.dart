import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/catch_entry.dart';
import '../services/catch_log_service.dart';
import 'add_catch_screen.dart';

class CatchLogScreen extends StatefulWidget {
  const CatchLogScreen({super.key});

  @override
  State<CatchLogScreen> createState() => _CatchLogScreenState();
}

class _CatchLogScreenState extends State<CatchLogScreen> {
  final CatchLogService _catchLogService = CatchLogService();
  final TextEditingController _searchController = TextEditingController();
  
  List<CatchEntry> _allCatches = [];
  List<CatchEntry> _filteredCatches = [];
  bool _isLoading = true;
  String? _error;
  Map<String, int> _speciesStats = {};
  int _totalCatches = 0;

  @override
  void initState() {
    super.initState();
    _loadCatchData();
    _searchController.addListener(_filterCatches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatchData() async {
    try {
      final catches = await _catchLogService.getAllCatchEntries();
      final stats = await _catchLogService.getCatchCountBySpecies();
      final total = await _catchLogService.getTotalCatchCount();
      
      setState(() {
        _allCatches = catches;
        _filteredCatches = catches;
        _speciesStats = stats;
        _totalCatches = total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load catch data: $e';
        _isLoading = false;
      });
    }
  }

  void _filterCatches() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCatches = _allCatches;
      } else {
        _filteredCatches = _allCatches.where((catchEntry) =>
          catchEntry.fishName.toLowerCase().contains(query) ||
          catchEntry.notes?.toLowerCase().contains(query) == true ||
          catchEntry.location?.toLowerCase().contains(query) == true
        ).toList();
      }
    });
  }

  Future<void> _deleteCatch(CatchEntry catchEntry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Catch'),
        content: Text('Are you sure you want to delete this catch of ${catchEntry.fishName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _catchLogService.deleteCatchEntry(catchEntry.id);
        await _loadCatchData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Catch deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete catch: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catch Log'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCatchScreen(),
                ),
              );
              if (result == true) {
                _loadCatchData();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search catches by fish, location, or notes...',
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
          
          // Statistics section
          if (!_isLoading && _totalCatches > 0) _buildStatisticsSection(),
          
          // Results
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCatchScreen(),
            ),
          );
          if (result == true) {
            _loadCatchData();
          }
        },
        backgroundColor: Colors.orange[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Catches',
                  _totalCatches.toString(),
                  Icons.sports_baseball,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Species Caught',
                  _speciesStats.length.toString(),
                  Icons.pets,
                  Colors.green,
                ),
              ),
            ],
          ),
          if (_speciesStats.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Top Species:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _speciesStats.entries.take(3).map((entry) {
                return Chip(
                  label: Text('${entry.key} (${entry.value})'),
                  backgroundColor: Colors.orange[100],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[700],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading catch log...',
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
              onPressed: _loadCatchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredCatches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty ? Icons.water : Icons.search_off,
              color: Colors.grey,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty ? 'No catches yet' : 'No catches found',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Start by identifying a fish or adding a catch manually'
                  : 'Try adjusting your search terms',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchController.text.isEmpty) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCatchScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadCatchData();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add First Catch'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredCatches.length,
      itemBuilder: (context, index) {
        final catchEntry = _filteredCatches[index];
        return _buildCatchCard(catchEntry);
      },
    );
  }

  Widget _buildCatchCard(CatchEntry catchEntry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showCatchDetails(catchEntry),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Fish photo or icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: catchEntry.photoPath != null && !kIsWeb
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(catchEntry.photoPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.pets,
                              color: Colors.blue[600],
                              size: 30,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.pets,
                        color: Colors.blue[600],
                        size: 30,
                      ),
              ),
              
              const SizedBox(width: 16),
              
              // Catch information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catchEntry.fishName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      catchEntry.fishScientificName,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy • h:mm a').format(catchEntry.catchDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (catchEntry.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              catchEntry.location!,
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
                    if (catchEntry.notes != null && catchEntry.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        catchEntry.notes!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Delete button
              IconButton(
                onPressed: () => _deleteCatch(catchEntry),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Delete catch',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCatchDetails(CatchEntry catchEntry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Title
                Text(
                  catchEntry.fishName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  catchEntry.fishScientificName,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Details
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Date', DateFormat('MMMM dd, yyyy').format(catchEntry.catchDate)),
                        _buildDetailRow('Time', DateFormat('h:mm a').format(catchEntry.catchDate)),
                        if (catchEntry.location != null)
                          _buildDetailRow('Location', catchEntry.location!),
                        if (catchEntry.weight != null)
                          _buildDetailRow('Weight', '${catchEntry.weight!.toStringAsFixed(1)} lbs'),
                        if (catchEntry.length != null)
                          _buildDetailRow('Length', '${catchEntry.length!.toStringAsFixed(1)} inches'),
                        if (catchEntry.weather != null)
                          _buildDetailRow('Weather', catchEntry.weather!),
                        if (catchEntry.bait != null)
                          _buildDetailRow('Bait Used', catchEntry.bait!),
                        if (catchEntry.notes != null && catchEntry.notes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            catchEntry.notes!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
