class CatchEntry {
  final String id;
  final String fishId;
  final String fishName;
  final String fishScientificName;
  final DateTime catchDate;
  final String? location;
  final String? notes;
  final String? photoPath;
  final double? weight;
  final double? length;
  final String? weather;
  final String? bait;

  CatchEntry({
    required this.id,
    required this.fishId,
    required this.fishName,
    required this.fishScientificName,
    required this.catchDate,
    this.location,
    this.notes,
    this.photoPath,
    this.weight,
    this.length,
    this.weather,
    this.bait,
  });

  factory CatchEntry.fromJson(Map<String, dynamic> json) {
    return CatchEntry(
      id: json['id'] ?? '',
      fishId: json['fishId'] ?? '',
      fishName: json['fishName'] ?? '',
      fishScientificName: json['fishScientificName'] ?? '',
      catchDate: DateTime.parse(json['catchDate']),
      location: json['location'],
      notes: json['notes'],
      photoPath: json['photoPath'],
      weight: json['weight']?.toDouble(),
      length: json['length']?.toDouble(),
      weather: json['weather'],
      bait: json['bait'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fishId': fishId,
      'fishName': fishName,
      'fishScientificName': fishScientificName,
      'catchDate': catchDate.toIso8601String(),
      'location': location,
      'notes': notes,
      'photoPath': photoPath,
      'weight': weight,
      'length': length,
      'weather': weather,
      'bait': bait,
    };
  }

  CatchEntry copyWith({
    String? id,
    String? fishId,
    String? fishName,
    String? fishScientificName,
    DateTime? catchDate,
    String? location,
    String? notes,
    String? photoPath,
    double? weight,
    double? length,
    String? weather,
    String? bait,
  }) {
    return CatchEntry(
      id: id ?? this.id,
      fishId: fishId ?? this.fishId,
      fishName: fishName ?? this.fishName,
      fishScientificName: fishScientificName ?? this.fishScientificName,
      catchDate: catchDate ?? this.catchDate,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      weather: weather ?? this.weather,
      bait: bait ?? this.bait,
    );
  }

  @override
  String toString() {
    return 'CatchEntry(id: $id, fishName: $fishName, catchDate: $catchDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CatchEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

