import 'package:aavaazflutter/views/recording_src.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController _email = TextEditingController(text: "");

  final TextEditingController _password = TextEditingController(text: "");
  bool _loading = false;
  final _globalKey = GlobalKey<FormState>();

  TextEditingController get email => _email;
  TextEditingController get password => _password;
  bool get loading => _loading;
  GlobalKey get globalkey => _globalKey;

  void login(Function() fadeout) {
    FocusScope.of(_globalKey.currentContext!).unfocus();
    _loading = true;

    if (!_globalKey.currentState!.validate()) {
      _loading = false;
      notifyListeners();
      return;
    }
    // final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    // if (!passwordRegex.hasMatch(_password.text)) {
    //   _loading = false;
    //   notifyListeners();
    //   ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
    //     SnackBar(
    //         content: Text(
    //             "Password must contain at least one letter and one number")),
    //   );
    //   return;
    // }

    if (_email.text.isEmpty || _password.text.isEmpty) {
      _loading = false;
      notifyListeners();
      ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Email or Password cannot be empty")),
      );
      return;
    }

    if (_password.text.length < 6) {
      _loading = false;
      notifyListeners();
      ScaffoldMessenger.of(_globalKey.currentContext!).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters long")),
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      fadeout();
      _loading = false;
      Navigator.pushReplacement(
        _globalKey.currentContext!,
        PageRouteBuilder(
          transitionDuration:
              const Duration(milliseconds: 800), // Smooth fade-in
          pageBuilder: (context, animation, secondaryAnimation) =>
              RecordingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );

      notifyListeners();
    });
  }
}
