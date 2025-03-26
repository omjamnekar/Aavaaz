import 'package:flutter/material.dart';

class MicWaveViewModel extends ChangeNotifier {
  late AnimationController _controller;
  bool isRecording = false;

  // Language state
  String selectedLanguage = 'English';
  String targetLanguage = 'German';

  MicWaveViewModel(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    );
  }

  AnimationController get controller => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Swap languages
  void swapLanguages() {
    String temp = selectedLanguage;
    selectedLanguage = targetLanguage;
    targetLanguage = temp;
    notifyListeners();
  }

  // Toggle recording animation
  void toggleRecording() {
    if (isRecording) {
      _controller.reset();
    } else {
      _controller.repeat(reverse: true);
    }
    isRecording = !isRecording;
    notifyListeners();
  }
}
