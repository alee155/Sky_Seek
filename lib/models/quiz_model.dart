class QuizModel {
  final String id;
  final String level;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizModel({
    required this.id,
    required this.level,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      level: json['level'] ?? '',
      // API returns 'questionText' not 'question'
      question: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }
}
