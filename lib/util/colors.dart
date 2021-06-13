import 'dart:math';

import 'package:flutter/material.dart';

class BBSColors {
  static const Color red = Color(0xFFFF5722);
  static const Color orange = Color(0xFFFFB800);
  static const Color green = Color(0xFF009688);
  static const Color cyan = Color(0xFF2F4056);
  static const Color blue = Color(0xFF1E9FFF);
  static const Color black = Color(0xFF393D49);
  static  List<Color> gray = [
    Color(0xFFEEEEEE),
    Color(0xFFE2E2E2),
    Color(0xFFDDDDDD),
    Color(0xFFD2D2D2),
    Color(0xFFCCCCCC),
    Color(0xFFC2C2C2)
  ];
  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Colors.blueGrey.shade800,
    Colors.black87,
  ];
  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  //randomcolor
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}