import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _soundEffects = true;
  bool _music = true;
  bool _darkMode = false;

  bool get soundEffects => _soundEffects;
  bool get music => _music;
  bool get darkMode => _darkMode;

  void toggleSoundEffects(bool value) {
    _soundEffects = value;
    notifyListeners();
  }

  void toggleMusic(bool value) {
    _music = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}
