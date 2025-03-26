import 'dart:ui';

import 'package:aavaazflutter/constants/assets_constants.dart';
import 'package:aavaazflutter/constants/text_style.dart';
import 'package:aavaazflutter/widgets/custom_textfield.dart';
import 'package:aavaazflutter/widgets/fadin.dart';
import 'package:flutter/material.dart';
import '../viewmodels/login_vm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final loginVM = LoginViewModel();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    loginVM.addListener(() {
      setState(() {});
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);
  }

  @override
  void dispose() {
    loginVM.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool isKeybroadOpen = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isKeybroadOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      setState(() {});
    });
  }

  void startFadeOutAndNavigate() {
    loginVM.login(
      () {
        _fadeController.forward();
      },
    );
  }

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 3, 5),
        body: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value, // Apply fade-out effect
              child: child,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isKeybroadOpen) const Spacer(),
                FadeInAnimation(
                  duration: const Duration(milliseconds: 1000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsConstants.logo,
                        height: 70,
                        width: 70,
                      ),
                      const SizedBox(height: 10),
                      Hero(
                          tag: "mainTAG",
                          child: Text('AAVAAZ', style: AppTextStyles.title)),
                    ],
                  ),
                ),
                if (!isKeybroadOpen) const Spacer(),
                Flexible(
                  flex: 4,
                  child: FadeInAnimation(
                    duration: const Duration(milliseconds: 1400),
                    child: Form(
                      key: loginVM.globalkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email",
                              style: AppTextStyles.label,
                            ),
                          ),
                          const SizedBox(height: 5),
                          glassTextField(
                            hintText: 'abc@gmail.com',
                            controller: loginVM.email,
                            isPasswordField: false,
                            obscureText: false,
                            toggleObscureText: () => null,
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Password",
                              style: AppTextStyles.label,
                            ),
                          ),
                          const SizedBox(height: 5),
                          glassTextField(
                            hintText: 'Password',
                            controller: loginVM.password,
                            obscureText: isVisible,
                            isPasswordField: true,
                            toggleObscureText: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot password?',
                                style: AppTextStyles.label,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: loginVM.loading
                                ? null
                                : startFadeOutAndNavigate,
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 97, 155, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: loginVM.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {},
                            child: RichText(
                              text: const TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Color.fromARGB(106, 255, 255, 255),
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
