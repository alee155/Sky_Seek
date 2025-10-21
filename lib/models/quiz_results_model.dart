class QuizResultModel {
  final String id;
  final String level;
  final int totalMarks;
  final int obtainMarks;
  final DateTime createdAt;

  QuizResultModel({
    required this.id,
    required this.level,
    required this.totalMarks,
    required this.obtainMarks,
    required this.createdAt,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] ?? '',
      level: json['level'] ?? '',
      totalMarks: json['totalMarks'] ?? 0,
      obtainMarks: json['obtainMarks'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'totalMarks': totalMarks,
      'obtainMarks': obtainMarks,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
