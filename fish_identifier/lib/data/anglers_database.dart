import '../models/angler.dart';

class AnglersDatabase {
  static final AnglersDatabase _instance = AnglersDatabase._internal();
  factory AnglersDatabase() => _instance;
  AnglersDatabase._internal();

  final List<Angler> _anglersData = [
    Angler(
      id: '1',
      name: 'Mike Johnson',
      location: 'Lake Tahoe, CA',
      bio: 'Passionate bass fisherman with 15 years of experience. Love early morning fishing and sharing tips with fellow anglers.',
      favoriteFish: ['Largemouth Bass', 'Smallmouth Bass', 'Rainbow Trout'],
      experienceYears: 15,
      avatarIcon: 'fishing_rod',
      isOnline: true,
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      totalCatches: 1247,
      preferredFishingStyle: 'Bass Fishing',
      fishingSpots: ['Lake Tahoe', 'Donner Lake', 'Folsom Lake'],
    ),
    Angler(
      id: '2',
      name: 'Sarah Chen',
      location: 'Seattle, WA',
      bio: 'Fly fishing enthusiast specializing in trout and salmon. Always up for a fishing adventure in the Pacific Northwest.',
      favoriteFish: ['Rainbow Trout', 'Chinook Salmon', 'Steelhead'],
      experienceYears: 8,
      avatarIcon: 'nature_people',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      totalCatches: 892,
      preferredFishingStyle: 'Fly Fishing',
      fishingSpots: ['Puget Sound', 'Columbia River', 'Lake Washington'],
    ),
    Angler(
      id: '3',
      name: 'Jake Rodriguez',
      location: 'Austin, TX',
      bio: 'Multi-species angler who loves exploring new waters. From catfish to crappie, I fish it all!',
      favoriteFish: ['Catfish', 'Crappie', 'Largemouth Bass'],
      experienceYears: 12,
      avatarIcon: 'sports_baseball',
      isOnline: true,
      lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      totalCatches: 1563,
      preferredFishingStyle: 'Multi-Species',
      fishingSpots: ['Lake Travis', 'Lady Bird Lake', 'Lake Buchanan'],
    ),
    Angler(
      id: '4',
      name: 'Emily Davis',
      location: 'Miami, FL',
      bio: 'Saltwater fishing specialist with a passion for tarpon and snook. Love the challenge of big game fishing.',
      favoriteFish: ['Tarpon', 'Snook', 'Redfish'],
      experienceYears: 10,
      avatarIcon: 'waves',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      totalCatches: 743,
      preferredFishingStyle: 'Saltwater',
      fishingSpots: ['Biscayne Bay', 'Florida Keys', 'Everglades'],
    ),
    Angler(
      id: '5',
      name: 'David Kim',
      location: 'Denver, CO',
      bio: 'Mountain stream trout fisherman. Nothing beats the solitude of high-altitude fishing in Colorado.',
      favoriteFish: ['Rainbow Trout', 'Brown Trout', 'Cutthroat Trout'],
      experienceYears: 6,
      avatarIcon: 'landscape',
      isOnline: true,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      totalCatches: 456,
      preferredFishingStyle: 'Trout Fishing',
      fishingSpots: ['South Platte River', 'Clear Creek', 'Blue River'],
    ),
    Angler(
      id: '6',
      name: 'Lisa Thompson',
      location: 'Portland, OR',
      bio: 'Conservation-minded angler who practices catch and release. Love teaching new anglers about sustainable fishing.',
      favoriteFish: ['Steelhead', 'Chinook Salmon', 'Rainbow Trout'],
      experienceYears: 20,
      avatarIcon: 'eco',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 4)),
      totalCatches: 2103,
      preferredFishingStyle: 'Catch & Release',
      fishingSpots: ['Willamette River', 'Columbia River', 'Deschutes River'],
    ),
    Angler(
      id: '7',
      name: 'Carlos Mendez',
      location: 'Phoenix, AZ',
      bio: 'Desert fishing expert who knows all the hidden gems in Arizona. Specialize in bass and catfish.',
      favoriteFish: ['Largemouth Bass', 'Catfish', 'Crappie'],
      experienceYears: 18,
      avatarIcon: 'wb_sunny',
      isOnline: true,
      lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      totalCatches: 1876,
      preferredFishingStyle: 'Desert Fishing',
      fishingSpots: ['Lake Pleasant', 'Roosevelt Lake', 'Saguaro Lake'],
    ),
    Angler(
      id: '8',
      name: 'Amanda Foster',
      location: 'Nashville, TN',
      bio: 'Weekend warrior who loves fishing with family. Always looking for kid-friendly fishing spots.',
      favoriteFish: ['Bluegill', 'Crappie', 'Largemouth Bass'],
      experienceYears: 5,
      avatarIcon: 'family_restroom',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
      totalCatches: 234,
      preferredFishingStyle: 'Family Fishing',
      fishingSpots: ['Percy Priest Lake', 'Old Hickory Lake', 'Center Hill Lake'],
    ),
    Angler(
      id: '9',
      name: 'Robert Wilson',
      location: 'Minneapolis, MN',
      bio: 'Ice fishing enthusiast who embraces the cold. Love the challenge of winter fishing in Minnesota.',
      favoriteFish: ['Walleye', 'Northern Pike', 'Crappie'],
      experienceYears: 25,
      avatarIcon: 'ac_unit',
      isOnline: true,
      lastActive: DateTime.now().subtract(const Duration(minutes: 10)),
      totalCatches: 3421,
      preferredFishingStyle: 'Ice Fishing',
      fishingSpots: ['Lake Minnetonka', 'Mille Lacs Lake', 'Lake of the Woods'],
    ),
    Angler(
      id: '10',
      name: 'Jessica Park',
      location: 'San Diego, CA',
      bio: 'Kayak fishing specialist who loves the freedom of fishing from a kayak. Always exploring new coastal waters.',
      favoriteFish: ['Yellowtail', 'Calico Bass', 'Halibut'],
      experienceYears: 7,
      avatarIcon: 'kayaking',
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 6)),
      totalCatches: 567,
      preferredFishingStyle: 'Kayak Fishing',
      fishingSpots: ['Mission Bay', 'La Jolla', 'Point Loma'],
    ),
  ];

  Future<List<Angler>> getAllAnglers() async {
    // Simulate database delay
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_anglersData);
  }

  Future<Angler?> getAnglerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _anglersData.firstWhere((angler) => angler.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Angler>> searchAnglers(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerQuery = query.toLowerCase();
    return _anglersData.where((angler) =>
      angler.name.toLowerCase().contains(lowerQuery) ||
      angler.location.toLowerCase().contains(lowerQuery) ||
      angler.bio.toLowerCase().contains(lowerQuery) ||
      angler.favoriteFish.any((fish) => fish.toLowerCase().contains(lowerQuery)) ||
      angler.preferredFishingStyle.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<List<Angler>> getAnglersByLocation(String location) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerLocation = location.toLowerCase();
    return _anglersData.where((angler) =>
      angler.location.toLowerCase().contains(lowerLocation)
    ).toList();
  }

  Future<List<Angler>> getAnglersByFavoriteFish(String fishName) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final String lowerFishName = fishName.toLowerCase();
    return _anglersData.where((angler) =>
      angler.favoriteFish.any((fish) => fish.toLowerCase().contains(lowerFishName))
    ).toList();
  }

  Future<List<Angler>> getOnlineAnglers() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _anglersData.where((angler) => angler.isOnline).toList();
  }

  Future<List<Angler>> getAnglersByExperience(int minYears) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _anglersData.where((angler) => angler.experienceYears >= minYears).toList();
  }
}




