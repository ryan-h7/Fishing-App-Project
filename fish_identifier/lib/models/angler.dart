class Angler {
  final String id;
  final String name;
  final String location;
  final String bio;
  final List<String> favoriteFish;
  final int experienceYears;
  final String avatarIcon;
  final bool isOnline;
  final DateTime lastActive;
  final int totalCatches;
  final String preferredFishingStyle;
  final List<String> fishingSpots;

  Angler({
    required this.id,
    required this.name,
    required this.location,
    required this.bio,
    required this.favoriteFish,
    required this.experienceYears,
    required this.avatarIcon,
    this.isOnline = false,
    required this.lastActive,
    this.totalCatches = 0,
    this.preferredFishingStyle = 'General',
    this.fishingSpots = const [],
  });

  factory Angler.fromJson(Map<String, dynamic> json) {
    return Angler(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      favoriteFish: List<String>.from(json['favoriteFish'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      avatarIcon: json['avatarIcon'] ?? 'person',
      isOnline: json['isOnline'] ?? false,
      lastActive: DateTime.parse(json['lastActive']),
      totalCatches: json['totalCatches'] ?? 0,
      preferredFishingStyle: json['preferredFishingStyle'] ?? 'General',
      fishingSpots: List<String>.from(json['fishingSpots'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'bio': bio,
      'favoriteFish': favoriteFish,
      'experienceYears': experienceYears,
      'avatarIcon': avatarIcon,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'totalCatches': totalCatches,
      'preferredFishingStyle': preferredFishingStyle,
      'fishingSpots': fishingSpots,
    };
  }

  Angler copyWith({
    String? id,
    String? name,
    String? location,
    String? bio,
    List<String>? favoriteFish,
    int? experienceYears,
    String? avatarIcon,
    bool? isOnline,
    DateTime? lastActive,
    int? totalCatches,
    String? preferredFishingStyle,
    List<String>? fishingSpots,
  }) {
    return Angler(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      favoriteFish: favoriteFish ?? this.favoriteFish,
      experienceYears: experienceYears ?? this.experienceYears,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      totalCatches: totalCatches ?? this.totalCatches,
      preferredFishingStyle: preferredFishingStyle ?? this.preferredFishingStyle,
      fishingSpots: fishingSpots ?? this.fishingSpots,
    );
  }

  @override
  String toString() {
    return 'Angler(id: $id, name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Angler && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}




