import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class VerseQuoteWidget extends StatelessWidget {
  final String verse;
  final String reference;
  final bool showIcon;

  const VerseQuoteWidget({
    super.key,
    this.verse = 'For the word of God is alive and active',
    this.reference = 'Hebrews 4:12',
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (showIcon)
                  Icon(Icons.book, size: 36, color: theme.colorScheme.secondary)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        curve: Curves.elasticOut,
                      ),
                if (showIcon) const SizedBox(height: 12),
                Text(
                  '“$verse”',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '- $reference',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 1000.ms, delay: 500.ms)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
  }
}
