class Planet {
  final String id;
  final String name;
  final String image;
  final String type;
  final String symbol;
  final String position;
  final String diameter;
  final String mass;
  final String gravity;
  final String rotationPeriod;
  final String solarDay;
  final String orbitalPeriod;
  final String orbitalSpeed;
  final String moons;
  final String atmosphereComposition;
  final String atmospherePressure;
  final String temperatureMin;
  final String temperatureMax;
  final String distanceFromSun;
  final String eccentricity;
  final bool rings;
  final bool magneticField;
  final String surface;
  final String trivia;
  final bool supportsLife;

  Planet({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.symbol,
    required this.position,
    required this.diameter,
    required this.mass,
    required this.gravity,
    required this.rotationPeriod,
    required this.solarDay,
    required this.orbitalPeriod,
    required this.orbitalSpeed,
    required this.moons,
    required this.atmosphereComposition,
    required this.atmospherePressure,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.distanceFromSun,
    required this.eccentricity,
    required this.rings,
    required this.magneticField,
    required this.surface,
    required this.trivia,
    required this.supportsLife,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      image: json["image"] ?? '',
      type: json["type"] ?? '',
      symbol: json["symbol"] ?? '',
      position: json["position"] ?? '',
      diameter: json["diameter"] ?? '',
      mass: json["mass"] ?? '',
      gravity: json["gravity"] ?? '',
      rotationPeriod: json["rotation_period_days"] ?? '',
      solarDay: json["solar_day_days"] ?? '',
      orbitalPeriod: json["orbital_period_days"] ?? '',
      orbitalSpeed: json["orbital_speed"] ?? '',
      moons: json["moons"] ?? '',
      atmosphereComposition: json["atmosphere_composition"] ?? '',
      atmospherePressure: json["atmosphere_pressure_bar"] ?? '',
      temperatureMin: json["temperature_min"] ?? '',
      temperatureMax: json["temperature_max"] ?? '',
      distanceFromSun: json["distance_from_sun"] ?? '',
      eccentricity: json["eccentricity"] ?? '',
      rings: json["rings"] ?? false,
      magneticField: json["magnetic_field"] ?? false,
      surface: json["surface"] ?? '',
      trivia: json["trivia"] ?? '',
      supportsLife: json["supports_life"] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "type": type,
      "symbol": symbol,
      "position": position,
      "diameter": diameter,
      "mass": mass,
      "gravity": gravity,
      "rotation_period_days": rotationPeriod,
      "solar_day_days": solarDay,
      "orbital_period_days": orbitalPeriod,
      "orbital_speed": orbitalSpeed,
      "moons": moons,
      "atmosphere_composition": atmosphereComposition,
      "atmosphere_pressure_bar": atmospherePressure,
      "temperature_min": temperatureMin,
      "temperature_max": temperatureMax,
      "distance_from_sun": distanceFromSun,
      "eccentricity": eccentricity,
      "rings": rings,
      "magnetic_field": magneticField,
      "surface": surface,
      "trivia": trivia,
      "supports_life": supportsLife,
    };
  }
}
