class ApiConfig {
  // Base URL
  static const String baseUrl = "https://planets.dgexpense.com/api";

  // Auth endpoints
  static const String signupEndpoint = "$baseUrl/auth/signup";
  static const String signinEndpoint = "$baseUrl/auth/signin";
  static const String updatePasswordEndpoint = "$baseUrl/auth/updatePassword";
  static const String profileEndpoint = "$baseUrl/auth/profile";
  static const String deleteAccountEndpoint = "$baseUrl/auth/delete-profile";
  static const String editProfileEndpoint = "$baseUrl/auth/edit-profile";

  // Quiz endpoints
  static const String quizResultsEndpoint = "$baseUrl/result/getResults";
  static const String getQuizEndpoint = "$baseUrl/quizzes/getQuiz";
  static const String saveResultEndpoint = "$baseUrl/result/saveResult";

  // Planet endpoints
  static const String planetsEndpoint = "$baseUrl/planets/get-planets";
  static const String addToFavoritesEndpoint =
      "$baseUrl/planets/add-to-favorite";
  static const String removeFavoriteEndpoint =
      "$baseUrl/planets/removeFavorite";
  static const String getFavoritePlanetsEndpoint =
      "$baseUrl/planets/get-favorite-planets";
  static const String comparePlanetsEndpoint = "$baseUrl/planets/compare";

  // Galaxy endpoints
  static const String galaxiesEndpoint = "$baseUrl/galaxies/get-galaxies";
  static const String galaxyDetailsEndpoint =
      "$baseUrl/galaxies/get-galaxy-details";

  // Star endpoints
  static const String starsEndpoint = "$baseUrl/stars/get-stars";
  static const String starDetailsEndpoint = "$baseUrl/stars/get-star-details";

  // Satellite endpoints
  static const String satellitesEndpoint = "$baseUrl/satellites/get-satellites";
  static const String satelliteDetailsEndpoint =
      "$baseUrl/satellites/get-satellite-details";
}
