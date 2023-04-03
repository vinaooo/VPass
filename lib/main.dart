// ignore_for_file: avoid_print,

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'globals.dart';
import 'home.dart';

void main() {
  runApp(
    const Vpass(),
  );
  if (Platform.isLinux == true ||
      Platform.isWindows == true ||
      Platform.isMacOS == true) {
    DesktopWindow.setMinWindowSize(const Size(460, 900));
  }
  MobileAds.instance.initialize();
  debugPaintSizeEnabled = false;
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

  void savedConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var savedThemeBrightness = prefs.getInt('themeBrightness');
    var savedAccentColor = prefs.getInt('accentColor');

    if (savedThemeBrightness != null) {
      setState(
        () {
          isSaved = true;
          print('conseguiu ler');
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
          print('Opção salva: $themeBrightness');
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
      print('handleBrightnessChange:     $useLightMode');
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
    });
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
    return MaterialApp(
      title: 'VPass 7',
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: useMaterial3,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
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
  }
}
