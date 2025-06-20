import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: const Color(0xFF3E5F8A),
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text('Sound Effects'),
                    value: settings.soundEffects,
                    onChanged: settings.toggleSoundEffects,
                    activeColor: const Color(0xFFF4C430),
                  ).animate().fadeIn(duration: 500.ms),
                  SwitchListTile(
                    title: const Text('Music'),
                    value: settings.music,
                    onChanged: settings.toggleMusic,
                    activeColor: const Color(0xFFF4C430),
                  ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: settings.darkMode,
                    onChanged: settings.toggleDarkMode,
                    activeColor: const Color(0xFFF4C430),
                  ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  const SizedBox(height: 20),
                  const Text(
                    'Theme Preview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('Parchment'),
                        selected: true,
                        onSelected: (_) {},
                        selectedColor: const Color(0xFFF4C430),
                      ),
                      ChoiceChip(
                        label: const Text('Scroll'),
                        selected: false,
                        onSelected: (_) {},
                        selectedColor: const Color(0xFFF4C430),
                      ),
                      ChoiceChip(
                        label: const Text('Dark Navy'),
                        selected: false,
                        onSelected: (_) {},
                        selectedColor: const Color(0xFFF4C430),
                      ),
                    ],
                  ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
                  const SizedBox(height: 20),
                  const Text(
                    'Credits: Bible Trivia Quest Team\nVersion: 1.0.0',
                  ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
