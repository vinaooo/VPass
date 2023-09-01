import 'package:flutter/material.dart';
import 'dart:core';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'settings/settings.dart';
import 'generator.dart';
import 'globals.dart';
import 'animations.dart';
import 'ad_helper.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final bool useLightMode;
  final ColorSeed colorSelected;
  final void Function(bool useLightMode) handleBrightnessChange;
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

  int screenWidth = 0;
  double screenHeight = 0;

  BannerAd? bannerAd;
  bool _isLoaded = false;

  @override
  initState() {
    super.initState();

    // if (isAndroid) {
    //   BannerAd(
    //     adUnitId: AdHelper.bannerAdUnitId,
    //     size: AdSize(width: screenWidth, height: screenHeight.toInt()),
    //     request: const AdRequest(),
    //     listener: BannerAdListener(
    //       onAdLoaded: (ad) {
    //         setState(() {
    //           bannerAd = ad as BannerAd;
    //         });
    //       },
    //       onAdFailedToLoad: (ad, error) {
    //         // Releases an ad resource when it fails to load
    //         ad.dispose();
    //         debugPrint(
    //             'Ad load failed (code=${error.code} message=${error.message})');
    //       },
    //     ),
    //   ).load();
    // }
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

  bool isLoaded = false;

  void _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      // Unable to get width of anchored banner.
      return;
    }
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    controller.dispose();
    if (isAndroid) bannerAd?.dispose();
    // if (isAndroid) bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;

    _isLoaded = false;
    if (isAndroid) {
      _loadAd();
    }

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

  Widget createScreenFor(ScreenSelected screenSelected) {
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

  double adHeight = 0;
  @override
  Widget build(BuildContext context) {
    //bannerAd = null; //remove ad banner to test and prints

    if (isAndroid) {
      if (bannerAd != null) {
        adHeight = 80 + bannerAd!.size.height.toDouble();
      } else {
        adHeight = 80;
      }
    }

    return NavigationTransition(
      scaffoldKey: scaffoldKey,
      animationController: controller,
      railAnimation: railAnimation,
      body: createScreenFor(ScreenSelected.values[screenIndex]),
      navigationRail: NavigationRail(
        extended: true,
        backgroundColor: isLinux
            ? context.isDarkMode
                ? const Color.fromARGB(255, 44, 44, 44)
                : const Color.fromARGB(255, 250, 250, 250)
            : null,
        destinations: const [
          NavigationRailDestination(
              // padding: EdgeInsets.zero,
              icon: Icon(Icons.lock_outlined),
              label: Text('Generator'),
              selectedIcon: Icon(Icons.lock_open_outlined)),
          NavigationRailDestination(
            // padding: EdgeInsets.zero,
            icon: Icon(Icons.settings_outlined),
            label: Text('Settings'),
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
        child: Container(
          height: bannerAd == null ? 80 : adHeight,
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(
                children: [
                  if (bannerAd != null && _isLoaded)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: SizedBox(
                          width: bannerAd!.size.width.toDouble(),
                          height: bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd!),
                        ),
                      ),
                    ),
                ],
              ),

              // SizedBox(
              //   width: bannerAd == null ? 0 : bannerAd?.size.width.toDouble(),
              //   height:
              //       bannerAd == null ? 30 : bannerAd?.size.height.toDouble(),
              //   child: bannerAd != null
              //       ? AdWidget(ad: bannerAd!)
              //       : const Text('Sad to see you using an adblocker!'),
              // ),

              NavigationBar(
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
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CardCreator extends StatefulWidget {
  String title;

  CardCreator({
    super.key,
    required this.title,
    required this.child,
  });

  final Widget child;

  @override
  State<CardCreator> createState() => _CardCreatorState();
}

class _CardCreatorState extends State<CardCreator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
              child: Text(widget.title),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              shape: isLinux
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                  : null,
              color: isLinux
                  ? context.isDarkMode
                      ? cardColorDark
                      : const Color.fromARGB(255, 250, 250, 250)
                  : null,
              elevation: 1,
              child: widget.child,
            ),
          ],
        ),
      ],
    );
  }
}
