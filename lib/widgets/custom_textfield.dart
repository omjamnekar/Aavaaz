import 'dart:ui';
import 'package:flutter/material.dart';

Widget glassTextField({
  required String hintText,
  TextEditingController? controller,
  required bool obscureText,
  required bool isPasswordField,
  required Function() toggleObscureText,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextFormField(
          cursorColor: Colors.white,
          controller: controller,
          style: const TextStyle(color: Color.fromARGB(158, 255, 253, 253)),
          obscureText: obscureText,
          obscuringCharacter: '•',
          keyboardType: isPasswordField
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: isPasswordField
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: toggleObscureText,
                  )
                : null,
          ),
        ),
      ),
    ),
  );
}
