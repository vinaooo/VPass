// ignore_for_file: avoid_print,

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:desktop_window/desktop_window.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adwaita/adwaita.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'globals.dart';
import 'home.dart';
import 'version.dart';
//import 'ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PackageInfoUtils.initPackageInfo();

  //DesktopWindow.setMinWindowSize(const Size(784, 820));
  if (Platform.isLinux == true) {
    systemIsDesktop = true;
    // DesktopWindow.setWindowSize(const Size(784, 850));
  } else {
    systemIsDesktop == false;
  }
//  MobileAds.instance.initialize();

  runApp(
    const Vpass(),
  );
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

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  final Color _brandBlue = const Color(0xFF1E88E5);
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        lightColorScheme = lightDynamic.harmonized();
        // (Optional) Customize the scheme as desired. For example, one might
        // want to use a brand color to override the dynamic [ColorScheme.secondary].
        lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
        // (Optional) If applicable, harmonize custom colors.

        // Repeat for the dark color scheme.
        darkColorScheme = darkDynamic.harmonized();
        darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);

        //_isDemoUsingDynamicColors = true; // ignore, only for demo purposes
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _brandBlue,
          brightness: Brightness.dark,
        );
      }

      return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, ThemeMode currentMode, __) {
            return MaterialApp(
              title: 'VPass 7',
              themeMode: themeMode,
              theme: Platform.isLinux
                  ? AdwaitaThemeData.light()
                  : ThemeData(
                      //scaffoldBackgroundColor: ,

                      colorSchemeSeed:
                          localAccentColor != 10 ? colorSelected.color : null,
                      colorScheme: localAccentColor == 10 ? lightDynamic : null,
                      useMaterial3: useMaterial3,
                      brightness: Brightness.light,
                    ),
              darkTheme: Platform.isLinux
                  ? AdwaitaThemeData.dark()
                  : ThemeData(
                      colorSchemeSeed:
                          localAccentColor != 10 ? colorSelected.color : null,
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
    });
  }
}
