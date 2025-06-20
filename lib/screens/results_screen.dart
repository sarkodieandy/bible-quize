import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../components/animated_score_display.dart';
import '../providers/quiz_provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int score = args['score'];
    final int totalPoints = args['totalPoints'];
    final String? category = args['category'];
    final quiz = context.watch<QuizProvider>();

    // Determine motivational message
    String motivationalMessage;
    if (score >= 4) {
      motivationalMessage =
          '“Well done, good and faithful servant!”\n- Matthew 25:23';
    } else if (score >= 2) {
      motivationalMessage = '“Keep studying the Scriptures!”\n- 2 Timothy 2:15';
    } else {
      motivationalMessage =
          '“The word of God is alive and active.”\n- Hebrews 4:12';
    }

    final categoryScore = category != null
        ? quiz.categoryResults[category]!['score'] as int
        : 0;
    final categoryTotal = category != null
        ? quiz.categoryResults[category]!['total'] as int
        : 0;
    final categoryCompleted = category != null
        ? quiz.categoryResults[category]!['completed'] as bool
        : false;

    return Scaffold(
      appBar: AppBar(
        title: Text(category != null ? '$category Results' : 'Quiz Results'),
        backgroundColor: const Color(0xFF3E5F8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score Display
              AnimatedScoreDisplay(
                score: score,
              ).animate().fadeIn(duration: 600.ms),
              const SizedBox(height: 20),

              // Category Performance
              if (category != null)
                Text(
                  '$category Score: $categoryScore/$categoryTotal\nCompletion: ${categoryCompleted ? 'Completed' : 'In Progress'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),

              const SizedBox(height: 20),

              // Motivational Message
              Text(
                motivationalMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 600.ms),

              const SizedBox(height: 20),

              // Total Points
              Text(
                'Total Points: $totalPoints',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Color(0xFFF4C430)),
              ).animate().fadeIn(duration: 600.ms, delay: 700.ms),

              const SizedBox(height: 20),

              // Ads (replace testAdUnitId with your own)
              SizedBox(
                height: 60,
                child: AdWidget(
                  ad: BannerAd(
                    size: AdSize.banner,
                    adUnitId:
                        'ca-app-pub-5462334042904965/8367451271', // Test ID
                    listener: BannerAdListener(),
                    request: const AdRequest(),
                  )..load(),
                ),
              ),
              const SizedBox(height: 20),

              // Play Again Button
              FilledButton.icon(
                onPressed: () {
                  context.read<QuizProvider>().resetQuiz();
                  Navigator.pushReplacementNamed(context, '/quiz');
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Play Again'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                ),
              ).animate().moveY(duration: 600.ms, begin: 10.0, delay: 800.ms),

              const SizedBox(height: 10),

              // Home Button
              FilledButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
                icon: const Icon(Icons.home),
                label: const Text('Home'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                ),
              ).animate().moveY(duration: 600.ms, begin: 10.0, delay: 900.ms),

              const SizedBox(height: 10),

              // View Challenges Button
              FilledButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/daily'),
                icon: const Icon(Icons.star),
                label: const Text('View Challenges'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3E5F8A),
                ),
              ).animate().moveY(duration: 600.ms, begin: 10.0, delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }
}
