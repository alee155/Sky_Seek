class Star {
  final String id;
  final String name;
  final String image;
  final String type;
  final String distanceFromEarth;
  final String radius;
  final String surfaceTemperature;
  final String description;

  // Additional fields with default empty values for fields that might not be in the API response
  final String color;
  final String luminosity;
  final String mass;
  final String age;
  final String constellation;
  final String spectralClass;
  final bool hasExoplanets;
  final String trivia;

  Star({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.distanceFromEarth,
    required this.radius,
    required this.surfaceTemperature,
    required this.description,
    this.color = '',
    this.luminosity = '',
    this.mass = '',
    this.age = '',
    this.constellation = '',
    this.spectralClass = '',
    this.hasExoplanets = false,
    this.trivia = '',
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    // Determine star color based on temperature or type
    String color = '';
    final type = json["type"] ?? '';
    if (type.toLowerCase().contains('red')) {
      color = 'red';
    } else if (type.toLowerCase().contains('blue')) {
      color = 'blue';
    } else if (type.toLowerCase().contains('yellow')) {
      color = 'yellow';
    } else if (type.toLowerCase().contains('white')) {
      color = 'white';
    } else if (type.toLowerCase().contains('orange')) {
      color = 'orange';
    } else {
      color = 'white'; // Default color
    }

    return Star(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      type: json["type"] ?? '',
      distanceFromEarth: json["distanceFromEarth"] ?? '',
      radius: json["radius"] ?? '',
      surfaceTemperature: json["surfaceTemperature"] ?? '',
      description: json["description"] ?? '',
      // Optional fields
      color: color, // Derived from type
      luminosity: json["luminosity"] ?? '',
      mass: json["mass"] ?? '',
      age: json["age"] ?? '',
      constellation: json["constellation"] ?? '',
      spectralClass: json["spectralClass"] ?? '',
      hasExoplanets: json["hasExoplanets"] ?? false,
      trivia: json["trivia"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "type": type,
      "distanceFromEarth": distanceFromEarth,
      "radius": radius,
      "surfaceTemperature": surfaceTemperature,
      "description": description,
      "color": color,
      "luminosity": luminosity,
      "mass": mass,
      "age": age,
      "constellation": constellation,
      "spectralClass": spectralClass,
      "hasExoplanets": hasExoplanets,
      "trivia": trivia,
    };
  }
}
