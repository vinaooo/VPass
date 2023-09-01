import 'dart:core';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vpass/settings/aboutsection.dart';

import 'collaborate.dart';
import '../globals.dart';
import 'options.dart';
import 'themes.dart';

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
          border: isLinux && !isWeb
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
          color: isLinux && !isWeb
              ? context.isDarkMode
                  ? appBgDark
                  : appBgLight
              : null,
          child: ListView(
            children: <Widget>[
              ThemeSection(
                  handleBrightnessChange: widget.handleBrightnessChange,
                  handleColorSelect: widget.handleColorSelect),
              const SizedBox(
                height: 10,
              ),
              // const OptionsSection(),
              const SizedBox(
                height: 10,
              ),
              // const CollaborateSection(),
              const SizedBox(
                height: 10,
              ),
              // const VersionSection(),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// launchExternalLink(linkUrl) async {
//   final Uri url = Uri.parse(linkUrl);
//   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
//     throw Exception('Could not launch $url');
//   }
// }
