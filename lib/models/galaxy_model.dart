class Galaxy {
  final String id;
  final String name;
  final String image;
  final String type;
  final String constellation;
  final String distanceFromEarth;
  final String diameter;
  final String numberOfStars;
  final String discovered;
  final String description;

  Galaxy({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.constellation,
    required this.distanceFromEarth,
    required this.diameter,
    required this.numberOfStars,
    required this.discovered,
    required this.description,
  });

  factory Galaxy.fromJson(Map<String, dynamic> json) {
    return Galaxy(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      type: json["type"] ?? '',
      constellation: json["constellation"] ?? '',
      distanceFromEarth: json["distanceFromEarth"] ?? '',
      diameter: json["diameter"] ?? '',
      numberOfStars: json["numberOfStars"] ?? '',
      discovered: json["discovered"] ?? '',
      description: json["description"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "type": type,
      "constellation": constellation,
      "distanceFromEarth": distanceFromEarth,
      "diameter": diameter,
      "numberOfStars": numberOfStars,
      "discovered": discovered,
      "description": description,
    };
  }
}
