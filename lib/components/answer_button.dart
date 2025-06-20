import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback? onPressed;

  const AnswerButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // State-based styling
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    double elevation = 0;
    double borderWidth = 1.5;

    if (!isAnswered) {
      backgroundColor = isDarkMode
          ? theme.colorScheme.surfaceContainerHigh
          : Colors.white;
      borderColor = theme.colorScheme.outline.withOpacity(0.3);
      textColor = theme.colorScheme.onSurface;
    } else {
      if (isSelected && isCorrect) {
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.2);
        borderColor = const Color(0xFF4CAF50);
        textColor = const Color(0xFF4CAF50);
      } else if (isSelected) {
        backgroundColor = const Color(0xFFF44336).withOpacity(0.2);
        borderColor = const Color(0xFFF44336);
        textColor = const Color(0xFFF44336);
      } else if (isCorrect) {
        backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
        borderColor = const Color(0xFF4CAF50).withOpacity(0.5);
        textColor = const Color(0xFF4CAF50).withOpacity(0.8);
      } else {
        backgroundColor = isDarkMode
            ? theme.colorScheme.surfaceContainerHigh
            : Colors.white;
        borderColor = theme.colorScheme.outline.withOpacity(0.2);
        textColor = theme.colorScheme.onSurface.withOpacity(0.6);
      }
    }

    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedContainer(
            duration: 300.ms,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              boxShadow: [
                if (isSelected && !isAnswered)
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: borderColor, width: borderWidth),
                elevation: elevation,
                textStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: textColor, height: 1.4),
                    ),
                  ),
                  if (isAnswered)
                    Icon(
                      isSelected && isCorrect
                          ? Icons.check_circle_rounded
                          : isSelected
                          ? Icons.cancel_rounded
                          : isCorrect
                          ? Icons.check_circle_rounded
                          : null,
                      color: isSelected && isCorrect
                          ? const Color(0xFF4CAF50)
                          : isSelected
                          ? const Color(0xFFF44336)
                          : const Color(0xFF4CAF50),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        )
        .shimmer(
          delay: 300.ms,
          duration: 800.ms,
          color: theme.colorScheme.primary.withOpacity(0.05),
        );
  }
}
