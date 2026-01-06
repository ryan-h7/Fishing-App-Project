import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/catch_entry.dart';
import '../models/fish.dart';
import '../services/catch_log_service.dart';
import '../data/fish_database.dart';

class AddCatchScreen extends StatefulWidget {
  final Fish? preSelectedFish;
  final String? photoPath;

  const AddCatchScreen({
    super.key,
    this.preSelectedFish,
    this.photoPath,
  });

  @override
  State<AddCatchScreen> createState() => _AddCatchScreenState();
}

class _AddCatchScreenState extends State<AddCatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _catchLogService = CatchLogService();
  final _fishDatabase = FishDatabase();
  
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weatherController = TextEditingController();
  final _baitController = TextEditingController();

  Fish? _selectedFish;
  DateTime _catchDate = DateTime.now();
  TimeOfDay _catchTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedFish = widget.preSelectedFish;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _locationController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _weatherController.dispose();
    _baitController.dispose();
    super.dispose();
  }

  Future<void> _selectFish() async {
    final fish = await _fishDatabase.getAllFish();
    
    final selectedFish = await showDialog<Fish>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Fish Species'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: fish.length,
            itemBuilder: (context, index) {
              final currentFish = fish[index];
              return ListTile(
                leading: Icon(
                  Icons.pets,
                  color: Colors.blue[600],
                ),
                title: Text(currentFish.name),
                subtitle: Text(
                  currentFish.scientificName,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                onTap: () => Navigator.pop(context, currentFish),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedFish != null) {
      setState(() {
        _selectedFish = selectedFish;
      });
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _catchDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _catchDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _catchTime,
    );

    if (time != null) {
      setState(() {
        _catchTime = time;
      });
    }
  }

  Future<void> _saveCatch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFish == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a fish species'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final catchDateTime = DateTime(
        _catchDate.year,
        _catchDate.month,
        _catchDate.day,
        _catchTime.hour,
        _catchTime.minute,
      );

      final catchEntry = CatchEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fishId: _selectedFish!.id,
        fishName: _selectedFish!.name,
        fishScientificName: _selectedFish!.scientificName,
        catchDate: catchDateTime,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        photoPath: widget.photoPath,
        weight: _weightController.text.trim().isEmpty ? null : double.tryParse(_weightController.text.trim()),
        length: _lengthController.text.trim().isEmpty ? null : double.tryParse(_lengthController.text.trim()),
        weather: _weatherController.text.trim().isEmpty ? null : _weatherController.text.trim(),
        bait: _baitController.text.trim().isEmpty ? null : _baitController.text.trim(),
      );

      await _catchLogService.addCatchEntry(catchEntry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catch saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save catch: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Catch'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveCatch,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fish selection
                    _buildSection(
                      'Fish Species',
                      _buildFishSelection(),
                      required: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Date and time
                    _buildSection(
                      'Date & Time',
                      _buildDateTimeSelection(),
                      required: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location
                    _buildSection(
                      'Location',
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'Where did you catch this fish?',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Weight and length
                    Row(
                      children: [
                        Expanded(
                          child: _buildSection(
                            'Weight (lbs)',
                            TextFormField(
                              controller: _weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '0.0',
                                prefixIcon: Icon(Icons.fitness_center),
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'Enter a valid number';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSection(
                            'Length (inches)',
                            TextFormField(
                              controller: _lengthController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '0.0',
                                prefixIcon: Icon(Icons.straighten),
                              ),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  if (double.tryParse(value) == null) {
                                    return 'Enter a valid number';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Weather and bait
                    Row(
                      children: [
                        Expanded(
                          child: _buildSection(
                            'Weather',
                            TextFormField(
                              controller: _weatherController,
                              decoration: const InputDecoration(
                                hintText: 'Sunny, cloudy, etc.',
                                prefixIcon: Icon(Icons.wb_sunny),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSection(
                            'Bait Used',
                            TextFormField(
                              controller: _baitController,
                              decoration: const InputDecoration(
                                hintText: 'Worms, lures, etc.',
                                prefixIcon: Icon(Icons.sports_baseball),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Notes
                    _buildSection(
                      'Notes',
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Any additional notes about this catch...',
                          prefixIcon: Icon(Icons.note),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveCatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Save Catch',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSection(String title, Widget child, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildFishSelection() {
    return InkWell(
      onTap: _selectFish,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.pets,
              color: _selectedFish != null ? Colors.blue[600] : Colors.grey[400],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedFish?.name ?? 'Select fish species',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedFish != null ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(_catchDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: _selectTime,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _catchTime.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
