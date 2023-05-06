// ignore_for_file: avoid_print,

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'globals.dart';
import 'home.dart';

void main() async {
  runApp(
    const Vpass(),
  );
  if (Platform.isLinux == true ||
      Platform.isWindows == true ||
      Platform.isMacOS == true) {
    systemIsDesktop = true;
    DesktopWindow.setWindowSize(const Size(784, 850));
    DesktopWindow.setMinWindowSize(const Size(784, 820));
  } else {
    systemIsDesktop == false;
  }
//  MobileAds.instance.initialize();
  WidgetsFlutterBinding.ensureInitialized();
}

class Vpass extends StatefulWidget {
  const Vpass({super.key});

  @override
  State<Vpass> createState() => _VpassState();
}

class _VpassState extends State<Vpass> {
  String localThemeBrightness = '';
  bool useMaterial3 = true;

  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  bool isSaved = false;
  int themeBrightness = 2;
  int localAccentColor = 10;

  void savedConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var savedThemeBrightness = prefs.getInt('themeBrightness');
    int? savedAccentColor = prefs.getInt('accentColor');
    localAccentColor = savedAccentColor ?? 10;

    if (savedThemeBrightness != null) {
      setState(
        () {
          isSaved = true;
          themeBrightness = savedThemeBrightness;
          if (savedThemeBrightness == 0) {
            themeMode = ThemeMode.dark;
          }
          if (savedThemeBrightness == 1) {
            themeMode = ThemeMode.light;
          }
          if (savedThemeBrightness == 2) {
            themeMode = ThemeMode.system;
          }
          if (savedAccentColor == 0) {
            colorSelected = ColorSeed.values[0];
          }
          if (savedAccentColor == 1) {
            colorSelected = ColorSeed.values[1];
          }
          if (savedAccentColor == 2) {
            colorSelected = ColorSeed.values[2];
          }
          if (savedAccentColor == 3) {
            colorSelected = ColorSeed.values[3];
          }
          if (savedAccentColor == 4) {
            colorSelected = ColorSeed.values[4];
          }
          if (savedAccentColor == 5) {
            colorSelected = ColorSeed.values[5];
          }
          if (savedAccentColor == 6) {
            colorSelected = ColorSeed.values[6];
          }
          if (savedAccentColor == 7) {
            colorSelected = ColorSeed.values[7];
          }
          if (savedAccentColor == 8) {
            colorSelected = ColorSeed.values[8];
          }
          if (savedAccentColor == 9) {
            colorSelected = ColorSeed.values[9];
          }
        },
      );
    } else {
      themeMode = ThemeMode.system;
    }
  }

  @override
  void initState() {
    super.initState();
    savedConfigs();
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      //print('handleBrightnessChange:     $useLightMode');
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(
      () {
        if (value != 10) {
          colorSelected = ColorSeed.values[value];
        } else {
          localAccentColor = 10;
        }
      },
    );
  }

  bool get useLightMode {
    switch (themeBrightness) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        return SchedulerBinding //SystemMode
                .instance
                .platformDispatcher
                .platformBrightness ==
            Brightness.light;
      default:
        return SchedulerBinding //SystemMode
                .instance
                .platformDispatcher
                .platformBrightness ==
            Brightness.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'VPass 7',
        themeMode: themeMode,
        theme: ThemeData(
          colorSchemeSeed: localAccentColor != 10 ? colorSelected.color : null,
          colorScheme: localAccentColor == 10 ? lightDynamic : null,
          useMaterial3: useMaterial3,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: localAccentColor != 10 ? colorSelected.color : null,
          colorScheme: localAccentColor == 10 ? darkDynamic : null,
          useMaterial3: useMaterial3,
          brightness: Brightness.dark,
        ),
        home: Home(
          useLightMode: useLightMode,
          useMaterial3: useMaterial3,
          colorSelected: colorSelected,
          handleBrightnessChange: handleBrightnessChange,
          handleMaterialVersionChange: handleMaterialVersionChange,
          handleColorSelect: handleColorSelect,
        ),
      );
    });
  }
}
