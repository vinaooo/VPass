import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:core';

bool systemIsDesktop = false;

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

Color cardColorDark = const Color.fromARGB(255, 61, 61, 61);

Color appBgDark = const Color.fromARGB(255, 44, 44, 44);
Color passbgColor(context) {
  if (context.isDarkMode) {
    return cardColorDark;
  } else {
    return Colors.white;
  }
}

enum ScreenSelected {
  passGenerator(0),
  settings(1);

  const ScreenSelected(this.value);
  final int value;
}

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 800;
const double largeWidthBreakpoint = 1200;
const double transitionLength = 500;
const smallSpacing = 10.0;
const double widthConstraint = 450;

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
