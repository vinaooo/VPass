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
          border: Platform.isLinux
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
          color: appBgDark,
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
              '${PackageInfoUtils.getInfo('App name')} ${PackageInfoUtils.getInfo('App version')} ${PackageInfoUtils.getInfo('Build number')} ${PackageInfoUtils.getInfo('Build signature')} ${PackageInfoUtils.getInfo('Installer store')}'),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return CardCreator(
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Row(
                    children: [
                      Text('Others'),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('About'),
                  leading: const Icon(Icons.info_outline),
                  onTap: _showDialog,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Row(
                    children: [
                      Text('Collaborate'),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.coffee_outlined,
                                  size: 20,
                                ),
                                Text(
                                  'Pay me a coffee',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Fontelico.emo_beer, size: 15),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Pay me a beer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(FontAwesome5.ad),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Remove ads',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(
                            width: 4,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.sports_esports_rounded),
                                  Text(
                                    'Pay my children a xbox game',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
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
                                  bottomLeft: Platform.isLinux
                                      ? const Radius.circular(12)
                                      : const Radius.circular(8),
                                  bottomRight: Radius.zero,
                                ),
                              ),
                            ),
                            onPressed: launchGithub,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesome5.github,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Github',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesome5.telegram_plane,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Telegram',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.translate,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Translate',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
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
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Row(
                  children: [
                    Text('Options'),
                  ],
                ),
              ),
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
