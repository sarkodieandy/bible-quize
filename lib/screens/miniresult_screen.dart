import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../components/animated_score_display.dart';
import '../providers/quiz_provider.dart';

class MiniResultsScreen extends StatefulWidget {
  const MiniResultsScreen({super.key});

  @override
  State<MiniResultsScreen> createState() => _MiniResultsScreenState();
}

class _MiniResultsScreenState extends State<MiniResultsScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5462334042904965/9502323562', // Test Ad Unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('MiniResultsScreen ad failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final int score = args?['score'] ?? 0;
    final int totalPoints = args?['totalPoints'] ?? 0;
    final quiz = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Results'),
        backgroundColor: const Color(0xFF3E5F8A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedScoreDisplay(
                      score: score,
                    ).animate().fadeIn(duration: 600.ms),
                    const SizedBox(height: 20),
                    Text(
                      'Round Score: $score/5\n'
                      'Total Progress: ${quiz.totalAnswered}/50 questions\n'
                      'Correct: ${quiz.totalCorrect}\n'
                      'Points: $totalPoints',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3E5F8A),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                    const SizedBox(height: 20),
                    if (quiz.achievements.isNotEmpty)
                      Column(
                        children: quiz.achievements
                            .map(
                              (achievement) =>
                                  ListTile(
                                    leading: const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 48, 68, 244),
                                    ),
                                    title: Text(
                                      'Achievement Unlocked: $achievement!',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF6D9886),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ).animate().fadeIn(
                                    duration: 600.ms,
                                    delay: 600.ms,
                                  ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<QuizProvider>().resetQuiz();
                        Navigator.pushReplacementNamed(context, '/quiz');
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Next Round'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 700.ms,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 800.ms,
                    ),
                  ],
                ),
              ),
            ),
            if (_isAdLoaded && _bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
