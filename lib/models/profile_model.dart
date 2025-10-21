class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final List<String> favoritePlanets;
  final String createdAt;
  final String updatedAt;
  
  // Create a sample profile for offline mode or when server is unavailable
  static ProfileModel sampleProfile() {
    return ProfileModel(
      id: 'offline-user',
      firstName: 'Guest',
      lastName: 'User',
      email: 'guest@example.com',
      gender: 'Not specified',
      favoritePlanets: ['Earth'],
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.favoritePlanets,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      favoritePlanets: List<String>.from(json['favoritePlanets'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
