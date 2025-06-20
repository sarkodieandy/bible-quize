import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

import '../components/answer_button.dart';
import '../components/question_card.dart';
import '../providers/quiz_provider.dart';
import '../providers/settings_provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  RewardedAd? _rewardedAd;
  bool _isRewardedLoaded = false;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
    final quiz = context.read<QuizProvider>();
    if (quiz.mode == QuizMode.timed) _startTimer();

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-5462334042904965/5371506860', // Banner ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          debugPrint('Banner load failed: $err');
        },
      ),
    )..load();

    _loadRewardedAd();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) context.read<QuizProvider>().tickTimer(context);
    });
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: '', // RewardedAd ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => setState(() {
          _rewardedAd = ad;
          _isRewardedLoaded = true;
        }),
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load rewarded ad: $error');
          _isRewardedLoaded = false;
        },
      ),
    );
  }

  void _showRewardedHint(QuizProvider quiz) {
    if (_isRewardedLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
          quiz.useHint();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _loadRewardedAd();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (_, __) {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad not ready yet, try again soon.')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _bannerAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<QuizProvider, SettingsProvider>(
      builder: (context, quiz, settings, child) {
        if (quiz.questions.isEmpty ||
            quiz.currentQuestion >= quiz.questions.length) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quiz'),
              backgroundColor: const Color(0xFF3E5F8A),
              foregroundColor: Colors.white,
            ),
            body: const Center(child: Text('No questions available')),
          );
        }

        final question = quiz.questions[quiz.currentQuestion];
        if (quiz.isAnswered && settings.soundEffects) {
          _confettiController.play();
          final isCorrect = quiz.selectedAnswer == question.answer;
          final sound = isCorrect ? 'sounds/s2.mp3' : 'sounds/s1.mp3';
          _audioPlayer.play(AssetSource(sound)).catchError((e) {
            debugPrint('Sound error: $e');
          });
        }

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  '${quiz.mode.name.toUpperCase()} Quiz: ${quiz.selectedCategory ?? 'Mixed'}',
                ),
                backgroundColor: const Color(0xFF3E5F8A),
                foregroundColor: Colors.white,
                actions: quiz.mode == QuizMode.timed
                    ? [
                        IconButton(
                          icon: Icon(
                            quiz.isTimerRunning
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            if (quiz.isTimerRunning) {
                              quiz.pauseTimer();
                            } else {
                              quiz.resumeTimer();
                              _startTimer();
                            }
                          },
                        ),
                      ]
                    : null,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Points: ${quiz.totalPoints}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6195D8),
                                  ),
                                ).animate().fadeIn(duration: 500.ms),
                                Text(
                                  'Q ${quiz.currentQuestion + 1}/${quiz.questions.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E5F8A),
                                  ),
                                ).animate().fadeIn(duration: 500.ms),
                              ],
                            ),
                            if (quiz.mode == QuizMode.timed) ...[
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: quiz.timeLeft / 15,
                                color: quiz.timeLeft > 10
                                    ? const Color(0xFF6D9886)
                                    : const Color(0xFF7271DB),
                              ),
                              Text(
                                'Time Left: ${quiz.timeLeft}s',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: quiz.timeLeft > 10
                                      ? const Color(0xFF3E5F8A)
                                      : const Color(0xFF72A9D6),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            QuestionCard(
                              question: question.question,
                              reference: null,
                              currentIndex: quiz.currentQuestion,
                              totalQuestions: quiz.questions.length,
                            ),
                            const SizedBox(height: 20),
                            ...question.options.map(
                              (option) => AnswerButton(
                                text: option,
                                isSelected: quiz.selectedAnswer == option,
                                isCorrect:
                                    quiz.isAnswered &&
                                    option == question.answer,
                                isAnswered: quiz.isAnswered,
                                onPressed: quiz.isAnswered
                                    ? null
                                    : () => quiz.checkAnswer(option, context),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (quiz.isAnswered)
                              FilledButton(
                                    onPressed: () => quiz.nextQuestion(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF3E5F8A),
                                    ),
                                    child: const Text('Next'),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .moveY(
                                    begin: 10,
                                    end: 0,
                                    duration: 600.ms,
                                    curve: Curves.easeOut,
                                  ),
                            const SizedBox(height: 10),
                            FilledButton.icon(
                              onPressed:
                                  quiz.totalPoints >= 5 && !quiz.isAnswered
                                  ? () => _showRewardedHint(quiz)
                                  : null,
                              icon: const Icon(Icons.lightbulb),
                              label: const Text('Hint (-5 points)'),
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    quiz.totalPoints >= 5 && !quiz.isAnswered
                                    ? const Color(0xFF646BDF)
                                    : Colors.grey,
                              ),
                            ).animate().fadeIn(duration: 600.ms),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    if (_isBannerLoaded && _bannerAd != null)
                      SizedBox(
                        height: _bannerAd!.size.height.toDouble(),
                        width: _bannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: 3.14 / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.3,
                colors: const [
                  Color(0xFF73A4D3),
                  Color(0xFF6D9886),
                  Color(0xFF3E5F8A),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
