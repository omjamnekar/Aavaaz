import 'package:flutter/material.dart';

class SplashViewModel {
  static const String appName = "AAVAAZ";
  static const String tagline = "Bringing the Patient’s Voice to Life";
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController textController;
  late Animation<Offset> animation1;
  late Animation<Offset> animation2;
  late Animation<Offset> textOffsetAnimation;
  late Animation<double> textOpacityAnimation;

  final ValueNotifier<bool> isEnd = ValueNotifier(false);

  void init(TickerProvider vsync) {
    controller1 =
        AnimationController(vsync: vsync, duration: const Duration(seconds: 12))
          ..repeat(reverse: true);
    controller2 =
        AnimationController(vsync: vsync, duration: const Duration(seconds: 14))
          ..repeat(reverse: true);

    animation1 = Tween<Offset>(
            begin: const Offset(-0.03, -0.03), end: const Offset(0.03, 0.03))
        .animate(CurvedAnimation(parent: controller1, curve: Curves.easeInOut));

    animation2 = Tween<Offset>(
            begin: const Offset(0.04, -0.02), end: const Offset(-0.04, 0.02))
        .animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut));

    textController =
        AnimationController(vsync: vsync, duration: const Duration(seconds: 2));

    textOffsetAnimation = Tween<Offset>(
            begin: const Offset(0, 8.5), end: const Offset(0, 2))
        .animate(
            CurvedAnimation(parent: textController, curve: Curves.easeOutCubic))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isEnd.value = true;
        }
      });

    textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeIn),
    );

    textController.forward();
  }

  void dispose() {
    controller1.dispose();
    controller2.dispose();
    textController.dispose();
  }
}
