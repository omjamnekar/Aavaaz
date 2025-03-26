import 'package:aavaazflutter/views/login_src.dart';
import 'package:aavaazflutter/views/splash_src.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      title: 'Aavaaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: RecordingScreen()
      home: SplashScreen(),
      // home: LoginScreen(),
    );
  }
}
