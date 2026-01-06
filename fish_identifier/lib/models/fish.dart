class Fish {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String habitat;
  final String size;
  final String weight;
  final String season;
  final List<String> characteristics;
  final String imageUrl;
  final double confidence;

  Fish({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.habitat,
    required this.size,
    required this.weight,
    required this.season,
    required this.characteristics,
    required this.imageUrl,
    this.confidence = 0.0,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scientificName: json['scientificName'] ?? '',
      description: json['description'] ?? '',
      habitat: json['habitat'] ?? '',
      size: json['size'] ?? '',
      weight: json['weight'] ?? '',
      season: json['season'] ?? '',
      characteristics: List<String>.from(json['characteristics'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scientificName': scientificName,
      'description': description,
      'habitat': habitat,
      'size': size,
      'weight': weight,
      'season': season,
      'characteristics': characteristics,
      'imageUrl': imageUrl,
      'confidence': confidence,
    };
  }

  Fish copyWith({
    String? id,
    String? name,
    String? scientificName,
    String? description,
    String? habitat,
    String? size,
    String? weight,
    String? season,
    List<String>? characteristics,
    String? imageUrl,
    double? confidence,
  }) {
    return Fish(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      description: description ?? this.description,
      habitat: habitat ?? this.habitat,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      season: season ?? this.season,
      characteristics: characteristics ?? this.characteristics,
      imageUrl: imageUrl ?? this.imageUrl,
      confidence: confidence ?? this.confidence,
    );
  }
}

class FishIdentificationResult {
  final Fish? identifiedFish;
  final List<Fish> possibleMatches;
  final String? error;
  final String? capturedImagePath;

  FishIdentificationResult({
    this.identifiedFish,
    this.possibleMatches = const [],
    this.error,
    this.capturedImagePath,
  });

  bool get isSuccessful => identifiedFish != null && error == null;
  bool get hasError => error != null;
}

