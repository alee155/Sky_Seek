class Satellite {
  final String id;
  final String name;
  final String image;
  final String type;
  final String launchedBy;
  final String launchDate;
  final String orbitAltitude;
  final String mass;
  final String description;

  Satellite({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.launchedBy,
    required this.launchDate,
    required this.orbitAltitude,
    required this.mass,
    required this.description,
  });

  factory Satellite.fromJson(Map<String, dynamic> json) {
    return Satellite(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      type: json["type"] ?? '',
      launchedBy: json["launchedBy"] ?? '',
      launchDate: json["launchDate"] ?? '',
      orbitAltitude: json["orbitAltitude"] ?? '',
      mass: json["mass"] ?? '',
      description: json["description"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "type": type,
      "launchedBy": launchedBy,
      "launchDate": launchDate,
      "orbitAltitude": orbitAltitude,
      "mass": mass,
      "description": description,
    };
  }
}
