import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedScoreDisplay extends StatelessWidget {
  final int score;

  const AnimatedScoreDisplay({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final validScore = score.clamp(0, double.infinity).toInt();

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: validScore),
      duration: const Duration(seconds: 2),
      builder: (context, value, _) {
        return Text(
              'Your Score: $value',
              style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E5F8A),
                  ) ??
                  const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E5F8A),
                  ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            )
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
      },
    );
  }
}
