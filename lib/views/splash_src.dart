import 'package:aavaazflutter/constants/assets_constants.dart';
import 'package:aavaazflutter/constants/text_style.dart';
import 'package:aavaazflutter/viewmodels/splash_vm.dart';
import 'package:aavaazflutter/views/login_src.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late SplashViewModel splashVM;
  late AnimationController _fadeOutController;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    splashVM = SplashViewModel();
    splashVM.init(this);

    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut),
    );

    _navigateToLogin();
  }

  @override
  void dispose() {
    splashVM.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 3, 5),
      body: FadeTransition(
        opacity: _fadeOutAnimation,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsConstants.backgroundImage),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 90,
              left: -150,
              child: SlideTransition(
                position: splashVM.animation1,
                child: ValueListenableBuilder(
                  valueListenable: splashVM.isEnd,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      opacity: value ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 1000),
                      child: Image.asset(
                        AssetsConstants.ellipse1,
                        opacity: splashVM.controller2
                            .drive(Tween<double>(begin: 0.5, end: 1.0)),
                        width: 400,
                        height: 400,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: SlideTransition(
                position: splashVM.animation2,
                child: ValueListenableBuilder(
                  valueListenable: splashVM.isEnd,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      opacity: value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: Image.asset(
                        AssetsConstants.ellipse2,
                        opacity: splashVM.controller2
                            .drive(Tween<double>(begin: 0.5, end: 1.0)),
                        width: 400,
                        height: 400,
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: splashVM.textOpacityAnimation,
                child: SlideTransition(
                  position: splashVM.textOffsetAnimation,
                  child: Hero(
                    tag: "mainTAG",
                    child: const Text(
                      SplashViewModel.appName,
                      style: AppTextStyles.heading,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, 150),
                child: ValueListenableBuilder(
                  valueListenable: splashVM.isEnd,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      opacity: value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        SplashViewModel.tagline,
                        style: AppTextStyles.tagline,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 4), () async {
      if (splashVM.isEnd.value) {
        await _fadeOutController.forward();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var fadeAnimation = animation.drive(
                Tween<double>(begin: 0.0, end: 1.0).chain(
                  CurveTween(curve: Curves.easeInCubic),
                ),
              );
              return FadeTransition(
                opacity: fadeAnimation,
                child: child,
              );
            },
          ),
        );
      }
    });
  }
}
