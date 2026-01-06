import '../models/fish.dart';

class FishDatabase {
  static final FishDatabase _instance = FishDatabase._internal();
  factory FishDatabase() => _instance;
  FishDatabase._internal();

  final List<Fish> _fishData = [
    Fish(
      id: '1',
      name: 'Largemouth Bass',
      scientificName: 'Micropterus salmoides',
      description: 'A popular game fish known for its aggressive strikes and fighting ability. It has a large mouth that extends past the eye and a dark lateral stripe.',
      habitat: 'Freshwater lakes, ponds, rivers, and reservoirs with vegetation',
      size: '12-24 inches (30-61 cm)',
      weight: '1-10 pounds (0.5-4.5 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Large mouth extending past the eye',
        'Dark lateral stripe along the body',
        'Greenish to brownish coloration',
        'Distinctive jaw structure',
        'Prefers cover and structure'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '2',
      name: 'Smallmouth Bass',
      scientificName: 'Micropterus dolomieu',
      description: 'A smaller cousin of the largemouth bass, known for its bronze coloration and fighting spirit. It prefers cooler, clearer water.',
      habitat: 'Clear, cool streams, rivers, and lakes with rocky bottoms',
      size: '10-20 inches (25-51 cm)',
      weight: '1-6 pounds (0.5-2.7 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Bronze to brownish coloration',
        'Red eyes',
        'Vertical bars on sides',
        'Smaller mouth than largemouth',
        'Prefers rocky structure'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '3',
      name: 'Rainbow Trout',
      scientificName: 'Oncorhynchus mykiss',
      description: 'A beautiful fish with a distinctive pink stripe along its side. Popular among anglers for its acrobatic jumps and delicious taste.',
      habitat: 'Cold, clear streams, rivers, and lakes',
      size: '8-20 inches (20-51 cm)',
      weight: '1-8 pounds (0.5-3.6 kg)',
      season: 'Year-round in suitable waters',
      characteristics: [
        'Pink to red lateral stripe',
        'Spotted body',
        'White belly',
        'Small scales',
        'Prefers cold, oxygen-rich water'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '4',
      name: 'Northern Pike',
      scientificName: 'Esox lucius',
      description: 'A long, slender predator with sharp teeth. Known for its aggressive nature and excellent fighting ability.',
      habitat: 'Weedy lakes, rivers, and backwaters',
      size: '20-40 inches (51-102 cm)',
      weight: '3-20 pounds (1.4-9 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Long, slender body',
        'Sharp teeth',
        'Dark spots on light background',
        'Duck-bill shaped snout',
        'Ambush predator'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '5',
      name: 'Walleye',
      scientificName: 'Sander vitreus',
      description: 'A popular game fish known for its excellent taste and challenging nature. It has distinctive glassy eyes that reflect light.',
      habitat: 'Deep, clear lakes and rivers',
      size: '14-30 inches (36-76 cm)',
      weight: '2-15 pounds (0.9-6.8 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Large, glassy eyes',
        'White spot on tail fin',
        'Olive to golden coloration',
        'Sharp teeth',
        'Nocturnal feeder'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '6',
      name: 'Bluegill',
      scientificName: 'Lepomis macrochirus',
      description: 'A small, colorful sunfish that is popular with beginners and provides excellent table fare.',
      habitat: 'Shallow, weedy areas of lakes and ponds',
      size: '4-12 inches (10-30 cm)',
      weight: '0.5-2 pounds (0.2-0.9 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Blue gill flap',
        'Dark spot on gill cover',
        'Vertical bars on sides',
        'Small mouth',
        'Schooling fish'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '7',
      name: 'Catfish',
      scientificName: 'Ictalurus punctatus',
      description: 'A bottom-dwelling fish with distinctive whiskers (barbels) and excellent taste. Known for its strong fighting ability.',
      habitat: 'Rivers, lakes, and ponds with muddy or sandy bottoms',
      size: '12-36 inches (30-91 cm)',
      weight: '2-50 pounds (0.9-23 kg)',
      season: 'Year-round',
      characteristics: [
        'Four pairs of whiskers (barbels)',
        'Smooth, scaleless skin',
        'Bottom feeder',
        'Strong, muscular body',
        'Nocturnal feeding habits'
      ],
      imageUrl: '',
    ),
    Fish(
      id: '8',
      name: 'Crappie',
      scientificName: 'Pomoxis annularis',
      description: 'A popular panfish known for its delicious white meat and schooling behavior. Often found in large groups.',
      habitat: 'Lakes, ponds, and slow-moving rivers with structure',
      size: '6-15 inches (15-38 cm)',
      weight: '0.5-3 pounds (0.2-1.4 kg)',
      season: 'Spring through Fall',
      characteristics: [
        'Compressed body shape',
        'Large mouth',
        'Dark spots on sides',
        'Schooling behavior',
        'Prefers cover and structure'
      ],
      imageUrl: '',
    ),
  ];

  Future<List<Fish>> getAllFish() async {
    // Simulate database delay
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_fishData);
  }

  Future<Fish?> getFishById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _fishData.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Fish>> searchFish(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerQuery = query.toLowerCase();
    return _fishData.where((fish) =>
      fish.name.toLowerCase().contains(lowerQuery) ||
      fish.scientificName.toLowerCase().contains(lowerQuery) ||
      fish.description.toLowerCase().contains(lowerQuery) ||
      fish.habitat.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<List<Fish>> getFishByHabitat(String habitat) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerHabitat = habitat.toLowerCase();
    return _fishData.where((fish) =>
      fish.habitat.toLowerCase().contains(lowerHabitat)
    ).toList();
  }

  Future<List<Fish>> getFishBySeason(String season) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerSeason = season.toLowerCase();
    return _fishData.where((fish) =>
      fish.season.toLowerCase().contains(lowerSeason)
    ).toList();
  }
}

