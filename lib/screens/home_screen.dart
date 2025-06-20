import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../components/verse_quote_widget.dart';
import '../providers/quiz_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5462334042904965/3801536215', // test ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed to load: $error');
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
        title: const Text('Bible Quiz'),
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
                    const Text(
                      'Test Your Bible Knowledge!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms),
                    const SizedBox(height: 10),
                    Text(
                      'Total Points: ${quiz.totalPoints}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 116, 128, 197),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<QuizProvider>().setMode(QuizMode.standard);
                        Navigator.pushNamed(context, '/quiz');
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Standard Quiz'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 200.ms,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<QuizProvider>().setMode(QuizMode.timed);
                        Navigator.pushNamed(context, '/quiz');
                      },
                      icon: const Icon(Icons.timer),
                      label: const Text('Timed Challenge'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 300.ms,
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      hint: const Text('Select Category'),
                      value: quiz.selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<QuizProvider>().setMode(
                            QuizMode.category,
                            category: value,
                          );
                          Navigator.pushNamed(context, '/quiz');
                        }
                      },
                      style: const TextStyle(
                        color: Color.fromARGB(255, 15, 15, 15),
                      ),
                      isExpanded: true,
                      dropdownColor: const Color.fromARGB(255, 238, 239, 241),
                      underline: Container(
                        height: 2,
                        color: const Color.fromARGB(255, 116, 171, 233),
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/daily'),
                      icon: const Icon(Icons.star),
                      label: const Text('Daily Challenge'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 500.ms,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/leaderboard'),
                      icon: const Icon(Icons.leaderboard),
                      label: const Text('Leaderboard'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 600.ms,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(Icons.settings),
                      label: const Text('Settings'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3E5F8A),
                      ),
                    ).animate().moveY(
                      duration: 600.ms,
                      begin: 10.0,
                      delay: 700.ms,
                    ),
                    const SizedBox(height: 30),
                    const VerseQuoteWidget().animate().fadeIn(
                      duration: 1000.ms,
                      delay: 800.ms,
                    ),
                  ],
                ),
              ),
            ),
            if (_isAdLoaded && _bannerAd != null)
              SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
