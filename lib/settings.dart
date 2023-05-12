import 'dart:io' show Platform;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'version.dart';
import 'home.dart';
import 'globals.dart';

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
      child: Container(
        decoration: BoxDecoration(
          border: isLinux
              ? context.isDarkMode
                  ? const Border(
                      top: BorderSide(color: Colors.transparent),
                      left: BorderSide(color: Color.fromARGB(255, 74, 74, 74)),
                      right: BorderSide(color: Colors.transparent),
                      bottom: BorderSide(color: Colors.transparent),
                    )
                  : const Border(
                      top: BorderSide(color: Colors.transparent),
                      left:
                          BorderSide(color: Color.fromARGB(255, 222, 222, 222)),
                      right: BorderSide(color: Colors.transparent),
                      bottom: BorderSide(color: Colors.transparent),
                    )
              : null,
        ),
        child: Container(
          color: context.isDarkMode ? appBgDark : appBgLight,
          child: ListView(
            children: <Widget>[
              ThemeSection(
                  handleBrightnessChange: widget.handleBrightnessChange,
                  handleColorSelect: widget.handleColorSelect),
              const SizedBox(
                height: 10,
              ),
              const OptionsSection(),
              const SizedBox(
                height: 10,
              ),
              const OthersSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class OthersSection extends StatefulWidget {
  const OthersSection({super.key});

  @override
  State<OthersSection> createState() => _OthersSectionState();
}

class _OthersSectionState extends State<OthersSection> {
  bool debugMode = true;
  bool printScreen = false;

  void _showDialog() {
    showAboutDialog(
        context: context,
        applicationName: PackageInfoUtils.getInfo('App name'),
        applicationIcon: const FlutterLogo(),
        applicationVersion: PackageInfoUtils.getInfo('App version'),
        children: [
          Text(
              '${PackageInfoUtils.getInfo('App name')} ${PackageInfoUtils.getInfo('App version')} build: ${PackageInfoUtils.getInfo('Build number')} ${PackageInfoUtils.getInfo('Build signature')} ${PackageInfoUtils.getInfo('Installer store')}'),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return CardCreator(
      title: 'Others',
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              ListTile(
                title: const Text('About'),
                horizontalTitleGap: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                ),
                subtitle:
                    const Text('Version, debug and Open Source Licenses.'),
                subtitleTextStyle: const TextStyle(fontSize: 13),
                leading: const Icon(Icons.info_outline),
                onTap: _showDialog,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 16),
                child: Row(
                  children: [
                    Text('Collaborate:'),
                  ],
                ),
              ),
              Column(
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 10,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.coffee_outlined,
                                size: 23,
                              ),
                              Text('Pay me a coffee'),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 9,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(Fontelico.emo_beer, size: 15),
                              Text('Pay me a beer'),
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 3,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            onPressed: isLinux ? null : () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(FontAwesome5.ad),
                                Text('Remove ads'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Expanded(
                          flex: 5,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(Icons.sports_esports_rounded),
                                Text('Pay my children a Xbox game'),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: isLinux
                                    ? const Radius.circular(12)
                                    : const Radius.circular(8),
                                bottomRight: Radius.zero,
                              ),
                            ),
                          ),
                          onPressed: launchGithub,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                FontAwesome5.github,
                                size: 20,
                              ),
                              Text('Github'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          onPressed: launchTelegram,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                FontAwesome5.telegram_plane,
                                size: 20,
                              ),
                              Text('Telegram'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.zero,
                                bottomRight: isLinux
                                    ? const Radius.circular(12)
                                    : const Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.translate,
                                size: 20,
                              ),
                              Text('Translate'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionsSection extends StatefulWidget {
  const OptionsSection({super.key});

  @override
  State<OptionsSection> createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<OptionsSection> {
  bool debugMode = true;
  bool printScreen = false;

  @override
  Widget build(BuildContext context) {
    return CardCreator(
      title: 'Options',
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              const CheckboxListTile(
                title: Text('Hide password'),
                value: true,
                secondary: Icon(Icons.screenshot),
                onChanged: null,
              ),
              CheckboxListTile(
                title: const Text('Debug mode'),
                value: debugMode,
                secondary: const Icon(Icons.bug_report),
                onChanged: null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThemeSection extends StatefulWidget {
  const ThemeSection({
    super.key,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;
  @override
  State<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends State<ThemeSection> {
  bool isNonModalBottomSheetOpen = false;

  var themeData = ThemeData();

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
          icon: const Icon(
            Icons.circle,
            color: Color(0xff6750a4),
          )),
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
      Text('Deep \nOrange', textAlign: TextAlign.center),
      Text('Pink'),
    ];

    themeButtonList = List.generate(
        themeButtonList.length,
        (index) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                themeButtonList[index],
                themeLabelList[index],
              ],
            ));

    accentButtonList = List.generate(
        accentButtonList.length,
        (index) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                accentButtonList[index],
                accentLabelList[index],
              ],
            ));
    return CardCreator(
      title: 'Appearence',
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
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
                            constraints: const BoxConstraints(
                              maxWidth: 640,
                              minWidth: 300,
                              maxHeight: 200,
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 10, 0, 0),
                                          child: Text(
                                            'Pick a theme:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GridView.count(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      children: themeButtonList,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
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
                            constraints: const BoxConstraints(
                              maxWidth: 640,
                              minWidth: 300,
                              maxHeight: 500,
                            ),
                            builder: (context) {
                              return FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Row(
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 10, 0, 0),
                                          child: Text(
                                            'Pick an accent color:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: FilledButton(
                                        onPressed: () {
                                          widget.handleColorSelect(10);
                                          saveAccentColor = 10;
                                          saveConfigs();
                                        },
                                        child: const Text('System Color'),
                                      ),
                                    ),
                                    GridView.count(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      shrinkWrap: true,
                                      crossAxisCount: 3,
                                      children: accentButtonList,
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

launchTelegram() async {
  const url = 'https://t.me/vinaooooooooo';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

launchGithub() async {
  const url = 'https://github.com/vinaooo/vpass';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}
