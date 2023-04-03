import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(
      {super.key,
      required this.handleBrightnessChange,
      required this.handleColorSelect});

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          BottomSheetSection(
              handleBrightnessChange: widget.handleBrightnessChange,
              handleColorSelect: widget.handleColorSelect),
        ],
      ),
    );
  }
}

class BottomSheetSection extends StatefulWidget {
  const BottomSheetSection({
    super.key,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;
  @override
  State<BottomSheetSection> createState() => _BottomSheetSectionState();
}

class _BottomSheetSectionState extends State<BottomSheetSection> {
  bool isNonModalBottomSheetOpen = false;

  int saveThemeBrightness = 2;
  int bsThemeBrightness = 2;
  int saveAccentColor = 1;
  int bsAccentColor = 1;

  Future<void> saveConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeBrightness', saveThemeBrightness);
    prefs.setInt('accentColor', saveAccentColor);
    setState(() {
      bsThemeBrightness = saveThemeBrightness;
      bsAccentColor = saveAccentColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final isBright = Theme.of(context).brightness == Brightness.light;
    List<Widget> themeButtonList = <Widget>[
      IconButton(
          icon: const Icon(Icons.light_mode_outlined),
          onPressed: () {
            widget.handleBrightnessChange(true);
            saveThemeBrightness = 1;
            saveConfigs();
          }),
      IconButton(
        //copia aqui
        icon: const Icon(Icons.dark_mode),
        onPressed: () {
          widget.handleBrightnessChange(false);
          saveThemeBrightness = 0;
          saveConfigs();
        },
      ),
      IconButton(
          onPressed: () {
            widget.handleBrightnessChange(SchedulerBinding
                    .instance.platformDispatcher.platformBrightness ==
                Brightness.light);
            saveThemeBrightness = 2;

            ///systemdefaults
            saveConfigs();
          },
          icon: const Icon(Icons.brightness_4_outlined)),
    ];
    List<Widget> accentButtonList = <Widget>[
      IconButton(
          onPressed: () {
            widget.handleColorSelect(0);
            saveAccentColor = 0;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Color(0xff6750a4))),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(1);
            saveAccentColor = 1;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.indigo)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(2);
            saveAccentColor = 2;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.blue)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(3);
            saveAccentColor = 3;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.teal)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(4);
            saveAccentColor = 4;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.green)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(5);
            saveAccentColor = 5;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.yellow)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(6);
            saveAccentColor = 6;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.orange)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(7);
            saveAccentColor = 7;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.deepOrange)),
      IconButton(
          onPressed: () {
            widget.handleColorSelect(8);
            saveAccentColor = 8;
            saveConfigs();
          },
          icon: const Icon(Icons.circle, color: Colors.pink)),
    ];
    List<Text> themeLabelList = const <Text>[
      Text('Light'),
      Text('Dark'),
      Text('System'),
    ];
    List<Text> accentLabelList = const <Text>[
      Text('Material'),
      Text('Indigo'),
      Text('Blue'),
      Text('Teal'),
      Text('Green'),
      Text('Yellow'),
      Text('Orange'),
      Text('Deep \nOrange',
      textAlign: TextAlign.center),
      Text('Pink'),
    ];

    themeButtonList = List.generate(
        themeButtonList.length,
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  themeButtonList[index],
                  themeLabelList[index],
                ],
              ),
            ));

    accentButtonList = List.generate(
        accentButtonList.length,
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  accentButtonList[index],
                  accentLabelList[index],
                ],
              ),
            ));
    return ComponentDecoration(
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                  child: Row(
                    children: [
                      Text("Appearance"),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'App theme',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            constraints: const BoxConstraints(maxWidth: 640),
                            builder: (context) {
                              return SizedBox(
                                height: 121,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: themeButtonList,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Accent color',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            constraints: const BoxConstraints(maxWidth: 640),
                            builder: (context) {
                              return SizedBox(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: SizedBox(
                                        height: 121,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: accentButtonList.sublist(0,3),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: SizedBox(
                                        height: 121,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: accentButtonList.sublist(3,6),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: SizedBox(
                                        height: 130,
                                        child: ListView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          children: accentButtonList.sublist(6,9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
