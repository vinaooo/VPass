import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io' show Platform;
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'settings.dart';
import 'generator.dart';
import 'globals.dart';
import 'animations.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.useMaterial3,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleMaterialVersionChange,
    required this.handleColorSelect,
  });

  final bool useLightMode;
  final bool useMaterial3;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function() handleMaterialVersionChange;
  final void Function(int value) handleColorSelect;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;

  int screenIndex = ScreenSelected.passGenerator.value;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;

    if (systemIsDesktop == true) {
      showMediumSizeLayout = false;
      showLargeSizeLayout = true;
      controller.value = 1;
    } else {
      if (width > mediumWidthBreakpoint) {
        if (width > largeWidthBreakpoint) {
          showMediumSizeLayout = false;
          showLargeSizeLayout = true;
        } else {
          showMediumSizeLayout = true;
          showLargeSizeLayout = false;
        }
        if (status != AnimationStatus.forward &&
            status != AnimationStatus.completed) {
          controller.forward();
        }
      } else {
        showMediumSizeLayout = false;
        showLargeSizeLayout = false;
        if (status != AnimationStatus.reverse &&
            status != AnimationStatus.dismissed) {
          controller.reverse();
        }
      }
      if (!controllerInitialized) {
        controllerInitialized = true;
        controller.value = width > mediumWidthBreakpoint ? 1 : 0;
      }
    }
  }

  void handleScreenChanged(int screenSelected) {
    setState(
      () {
        screenIndex = screenSelected;
      },
    );
  }

  Widget createScreenFor(
      ScreenSelected screenSelected, bool showNavBarExample) {
    switch (screenSelected) {
      case ScreenSelected.passGenerator:
        return const PasswordGenerator();
      case ScreenSelected.settings:
        return SettingsScreen(
          handleBrightnessChange: widget.handleBrightnessChange,
          handleColorSelect: widget.handleColorSelect,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          railAnimation: railAnimation,
          appBar: Platform.isAndroid == true
              ? AppBar(
                  title: const Text('VPass'),
                )
              : null,
          body: createScreenFor(
              ScreenSelected.values[screenIndex], controller.value == 1),
          navigationRail: NavigationRail(
            extended: showLargeSizeLayout,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.password_outlined),
                label: Text('Generator'),
                selectedIcon: Icon(Icons.password),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                label: Text('Settings'),
                selectedIcon: Icon(Icons.settings),
              ),
            ],
            selectedIndex: screenIndex,
            onDestinationSelected: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
          ),
          navigationBar: Focus(
            autofocus: true,
            child: NavigationBar(
              selectedIndex: screenIndex,
              onDestinationSelected: (index) {
                setState(() {
                  screenIndex = index;
                });
                screenIndex = screenIndex;
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.password_outlined),
                  label: 'Generator',
                  selectedIcon: Icon(Icons.password),
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                  selectedIcon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<InitializationStatus> _initGoogleMobileAds() {
  // ignore: todo
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }
}

class ComponentDecoration extends StatefulWidget {
  const ComponentDecoration({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ComponentDecoration> createState() => _ComponentDecorationState();
}

class _ComponentDecorationState extends State<ComponentDecoration> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.tightFor(width: widthConstraint),
            child: Focus(
              focusNode: focusNode,
              canRequestFocus: true,
              child: GestureDetector(
                onTapDown: (_) {
                  focusNode.requestFocus();
                },
                behavior: HitTestBehavior.opaque,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 0.0),
                        child: Center(
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
