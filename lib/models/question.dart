class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String difficulty;
  final String category;
  final String? reference; // Added as nullable

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.difficulty,
    required this.category,
    this.reference, // Added as optional
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      difficulty: json['difficulty'],
      category: json['category'],
      reference: json['reference'], // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
      'difficulty': difficulty,
      'category': category,
      'reference': reference, // Added
    };
  }
}
