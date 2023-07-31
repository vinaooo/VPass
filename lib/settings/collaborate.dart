import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:vpass/settings/settings.dart';

import '../globals.dart';
import '../home.dart';

class CollaborateSection extends StatefulWidget {
  const CollaborateSection({super.key});

  @override
  State<CollaborateSection> createState() => _CollaborateSectionState();
}

class _CollaborateSectionState extends State<CollaborateSection> {
  bool debugMode = true;
  bool printScreen = false;

  @override
  Widget build(BuildContext context) {
    return CardCreator(
      title: 'Collaborate',
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              // ListTile(
              //   title: const Text('About'),
              //   horizontalTitleGap: 0,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(12),
              //         topRight: Radius.circular(12)),
              //   ),
              //   subtitle:
              //       const Text('Version, debug and Open Source Licenses.'),
              //   subtitleTextStyle: const TextStyle(fontSize: 13),
              //   leading: const Icon(Icons.info_outline),
              //   onTap: _showDialog,
              // ),
              // const Padding(
              //   padding: EdgeInsets.fromLTRB(16, 8, 0, 16),
              //   child: Row(
              //     children: [
              //       Text('Collaborate:'),
              //     ],
              //   ),
              // ),
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
                                Text('Pay my children an Xbox game'),
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
