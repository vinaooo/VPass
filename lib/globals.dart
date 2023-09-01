import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:flutter/material.dart';
import 'dart:core';

bool systemIsDesktop = false;

bool isLinux = Platform.isLinux;
bool isAndroid = Platform.isAndroid;
bool isIos = Platform.isIOS;
bool isWeb = kIsWeb;
bool isWindows = Platform.isWindows;
bool isMacOS = Platform.isMacOS;

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

Color passwordCardColor(int securityNoPass, context, bool isDark) {
  if (securityNoPass == 0) {
    return Colors.red;
    // Color(Blend.harmonize(
    //     Theme.of(context).colorScheme.error.value, cardColorDark.value));
  } else if (securityNoPass == 1) {
    return Color(Blend.harmonize(Colors.red.value, cardColorDark.value));
  } else if (securityNoPass == 2) {
    return Color(
        Blend.harmonize(Colors.deepOrangeAccent.value, cardColorDark.value));
  } else if (securityNoPass == 3) {
    return Color(
        Blend.harmonize(Colors.orangeAccent.value, cardColorDark.value));
  } else if (securityNoPass == 4) {
    return Color(Blend.harmonize(Colors.amber.value, cardColorDark.value));
  } else if (securityNoPass == 5) {
    return Color(
        Blend.harmonize(Colors.amberAccent.value, cardColorDark.value));
  } else if (securityNoPass == 6) {
    return Color(Blend.harmonize(Colors.yellow.value, cardColorDark.value));
  } else if (securityNoPass == 7) {
    return Color(
        Blend.harmonize(const Color(0xffd0df00).value, cardColorDark.value));
  } else if (securityNoPass == 8) {
    return Color(
        Blend.harmonize(const Color(0xff36B37E).value, cardColorDark.value));
  } else if (securityNoPass == 9) {
    return Color(
        Blend.harmonize(const Color(0xff006644).value, cardColorDark.value));
  }

  return Colors.transparent;
}

Color cardColorDark = const Color.fromARGB(255, 61, 61, 61);

Color appBgDark = const Color.fromARGB(255, 44, 44, 44);
Color appBgLight = const Color.fromARGB(255, 255, 255, 255);
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
