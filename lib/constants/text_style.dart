import 'package:flutter/material.dart';

class AppTextStyles {
  // splash style

  static const heading = TextStyle(
    shadows: [
      Shadow(
        blurRadius: 10,
        color: Colors.black54,
        offset: Offset(0, 2),
      )
    ],
    letterSpacing: 20,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const tagline = TextStyle(
    fontSize: 16,
    color: Colors.white,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w100,
    fontFamily: "IBM Plex Sans",
  );

  // login style
  static const title = TextStyle(
    fontSize: 24,
    letterSpacing: 10,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  static const label = TextStyle(
    color: Color.fromARGB(255, 95, 178, 255),
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    fontSize: 12,
  );

  static const hint = TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  static const link = TextStyle(
    color: Colors.blueAccent,
    fontSize: 14,
    decoration: TextDecoration.underline,
  );
}
