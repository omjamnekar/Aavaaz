import 'package:flutter/services.dart';

class AudioRecorder {
  static const MethodChannel _channel = MethodChannel("audio_recorder");

  Future<void> startRecording() async {
    try {
      await _channel.invokeMethod("startRecording");
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      await _channel.invokeMethod("stopRecording");
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      await _channel.invokeMethod("playRecording");
    } catch (e) {
      print("Error playing recording: $e");
    }
  }

  Future<void> stopPlayRecording() async {
    try {
      await _channel.invokeMethod("stopPlayRecording");
    } catch (e) {
      print("Error playing recording: $e");
    }
  }
}
