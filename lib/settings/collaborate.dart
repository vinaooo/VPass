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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: null,
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
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Flexible(
                flex: 1,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: null,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Fontelico.emo_beer, size: 15),
                      Text('Pay me a beer'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 10,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: null,
                  // isLinux ? null : () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              Flexible(
                flex: 18,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: null,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(Icons.sports_esports_rounded),
                      Text('Pay me a Xbox Game'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
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
                  onPressed: () {
                    launchExternalLink('https://github.com/vinaooo/vpass');
                  },
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
              Flexible(
                flex: 1,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () {
                    launchExternalLink('https://t.me/vinaoooo');
                  },
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
              Flexible(
                flex: 1,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(0),
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
    );
  }
}
