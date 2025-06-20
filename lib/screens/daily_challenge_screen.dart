import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final categories = [
      'Old Testament',
      'New Testament',
      'Miracles',
      'Parables',
      'Verses',
      'General',
      'History',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenges'),
        backgroundColor: const Color(0xFF3E5F8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Complete Each Category!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 20),
              ...categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isCompleted =
                    quiz.categoryResults[category]!['completed'] as bool;
                final score = quiz.categoryResults[category]!['score'] as int;
                final total = quiz.categoryResults[category]!['total'] as int;
                return Card(
                  elevation: isCompleted ? 4 : 2,
                  child: ListTile(
                    leading: Icon(
                      isCompleted ? Icons.check_circle : Icons.lock,
                      color: isCompleted
                          ? const Color(0xFFF4C430)
                          : Colors.grey,
                    ),
                    title: Text(category),
                    subtitle: Text(
                      isCompleted
                          ? 'Completed: $score/$total'
                          : 'In Progress: $score/$total',
                    ),
                    trailing: isCompleted
                        ? const Icon(Icons.star, color: Color(0xFFF4C430))
                        : const Icon(Icons.arrow_forward),
                    onTap: () {
                      if (!isCompleted) {
                        context.read<QuizProvider>().setMode(
                          QuizMode.category,
                          category: category,
                        );
                        Navigator.pushNamed(context, '/quiz');
                      }
                    },
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: (index * 100).ms);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
