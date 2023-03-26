// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;
const double transitionLength = 500;
const colDivider = SizedBox(height: 10);
const smallSpacing = 10.0;
const double widthConstraint = 450;

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink),
  white('White', Colors.white);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

enum ScreenSelected {
  passGenerator(0),
  settings(1);

  const ScreenSelected(this.value);
  final int value;
}

void main() {
  runApp(
    const Vpass(),
  );
  if (Platform.isLinux == true ||
      Platform.isWindows == true ||
      Platform.isMacOS == true) {
    DesktopWindow.setMinWindowSize(const Size(460, 900));
  }
  WidgetsFlutterBinding.ensureInitialized();
}

class Vpass extends StatefulWidget {
  const Vpass({super.key});

  @override
  State<Vpass> createState() => _VpassState();
}

class _VpassState extends State<Vpass> {
  void handleBrightnessChange(bool useLightMode) {
    setState(() {
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

  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return SchedulerBinding
                .instance.platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

//gambiarra
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

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
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

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: const Text('VPass')
      //  widget.useMaterial3
      //     ? const Text('Material 3')
      //     : const Text('Material 2'),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey, //inicio?
          animationController: controller,
          railAnimation: railAnimation,
          appBar: createAppBar(),
          body: createScreenFor(
              ScreenSelected.values[screenIndex], controller.value == 1),
          navigationRail: NavigationRail(
            extended: showLargeSizeLayout,
            destinations: navRailDestinations,
            selectedIndex: screenIndex,
            onDestinationSelected: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
          ),
          navigationBar: NavigationBars(
            onSelectItem: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
            selectedIndex: screenIndex,
          ),
        );
      },
    );
  }
}

class NavigationTransition extends StatefulWidget {
  const NavigationTransition(
      {super.key,
      required this.scaffoldKey,
      required this.animationController,
      required this.railAnimation,
      required this.navigationRail,
      required this.navigationBar,
      required this.appBar,
      required this.body});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  final CurvedAnimation railAnimation;
  final Widget navigationRail;
  final Widget navigationBar;
  final PreferredSizeWidget appBar;
  final Widget body;

  @override
  State<NavigationTransition> createState() => _NavigationTransitionState();
}

class _NavigationTransitionState extends State<NavigationTransition> {
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  late final ReverseAnimation barAnimation;
  bool controllerInitialized = false;
  bool showDivider = false;

  @override
  void initState() {
    super.initState();

    controller = widget.animationController;
    railAnimation = widget.railAnimation;

    barAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: widget.scaffoldKey,
      appBar: widget.appBar,
      body: Row(
        children: <Widget>[
          RailTransition(
            animation: railAnimation,
            backgroundColor: colorScheme.surface,
            child: widget.navigationRail,
          ),
          widget.body,
        ],
      ),
      bottomNavigationBar: BarTransition(
        animation: barAnimation,
        backgroundColor: colorScheme.surface,
        child: widget.navigationBar,
      ),
    );
  }
}

final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.2,
            0.8,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation(Animation<double> parent)
      : super(
          parent: parent,
          curve: const Interval(
            0.4,
            1.0,
            curve: Curves.easeInOutCubicEmphasized,
          ),
          reverseCurve: Interval(
            0,
            0.2,
            curve: Curves.easeInOutCubicEmphasized.flipped,
          ),
        );
}

class RailTransition extends StatefulWidget {
  const RailTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<RailTransition> createState() => _RailTransition();
}

class _RailTransition extends State<RailTransition> {
  late Animation<Offset> offsetAnimation;
  late Animation<double> widthAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // The animations are only rebuilt by this method when the text
    // direction changes because this widget only depends on Directionality.
    final bool ltr = Directionality.of(context) == TextDirection.ltr;

    widthAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));

    offsetAnimation = Tween<Offset>(
      begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: widthAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class BarTransition extends StatefulWidget {
  const BarTransition(
      {super.key,
      required this.animation,
      required this.backgroundColor,
      required this.child});

  final Animation<double> animation;
  final Color backgroundColor;
  final Widget child;

  @override
  State<BarTransition> createState() => _BarTransition();
}

class _BarTransition extends State<BarTransition> {
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> heightAnimation;

  @override
  void initState() {
    super.initState();

    offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));

    heightAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor),
        child: Align(
          alignment: Alignment.topLeft,
          heightFactor: heightAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class OneTwoTransition extends StatefulWidget {
  const OneTwoTransition({
    super.key,
    required this.animation,
    required this.one,
    required this.two,
  });

  final Animation<double> animation;
  final Widget one;
  final Widget two;

  @override
  State<OneTwoTransition> createState() => _OneTwoTransitionState();
}

class _OneTwoTransitionState extends State<OneTwoTransition> {
  late final Animation<Offset> offsetAnimation;
  late final Animation<double> widthAnimation;

  @override
  void initState() {
    super.initState();

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));

    widthAnimation = Tween<double>(
      begin: 0,
      end: mediumWidthBreakpoint,
    ).animate(SizeAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: mediumWidthBreakpoint.toInt(),
          child: widget.one,
        ),
        if (widthAnimation.value.toInt() > 0) ...[
          Flexible(
            flex: widthAnimation.value.toInt(),
            child: FractionalTranslation(
              translation: offsetAnimation.value,
              child: widget.two,
            ),
          )
        ],
      ],
    );
  }
}

// settings screen

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

  @override
  Widget build(BuildContext context) {
    //final isBright = Theme.of(context).brightness == Brightness.light;
    List<Widget> themeButtonList = <Widget>[
      IconButton(
          icon: const Icon(Icons.light_mode_outlined),
          onPressed: () => widget.handleBrightnessChange(true)),
      IconButton(
        //copia aqui
        icon: const Icon(Icons.dark_mode),
        onPressed: () => widget.handleBrightnessChange(false),
      ),
      IconButton(
          onPressed: () {
            showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(content: const Text(
            'Sorry this is not implemented'),
        actions: <Widget>[
          FilledButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
          },
          icon: const Icon(Icons.brightness_4_outlined)),
    ];
    List<Widget> accentButtonList = <Widget>[
      IconButton(
          onPressed: () => widget.handleColorSelect(0),
          icon: const Icon(
            Icons.circle,
            color: Color(0xff6750a4),
          )),
      IconButton(
          onPressed: () => widget.handleColorSelect(1),
          icon: const Icon(Icons.circle, color: Colors.indigo)),
      IconButton(
          onPressed: () => widget.handleColorSelect(2),
          icon: const Icon(Icons.circle, color: Colors.blue)),
      IconButton(
          onPressed: () => widget.handleColorSelect(3),
          icon: const Icon(Icons.circle, color: Colors.teal)),
      IconButton(
          onPressed: () => widget.handleColorSelect(4),
          icon: const Icon(Icons.circle, color: Colors.green)),
      IconButton(
          onPressed: () => widget.handleColorSelect(5),
          icon: const Icon(Icons.circle, color: Colors.yellow)),
      IconButton(
          onPressed: () => widget.handleColorSelect(6),
          icon: const Icon(Icons.circle, color: Colors.orange)),
      IconButton(
          onPressed: () => widget.handleColorSelect(7),
          icon: const Icon(Icons.circle, color: Colors.deepOrange)),
      IconButton(
          onPressed: () => widget.handleColorSelect(8),
          icon: const Icon(Icons.circle, color: Colors.pink)),
      IconButton(
          onPressed: () => widget.handleColorSelect(9),
          icon: const Icon(Icons.circle, color: Colors.white)),
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
      Text('Deep Orange'),
      Text('Pink'),
      Text('White'),
    ];

    themeButtonList = List.generate(
        themeButtonList.length,
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 20.0),
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
                            borderRadius: BorderRadius.circular(8), // <-- Radius
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // <-- Radius
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
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: accentButtonList,
                                  ),
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

//password screen
class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );

    Widget schemeView(ThemeData theme) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: PasswordGeneratorPage(),
      );
    }

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: schemeView(lightTheme),
          ),
        ],
      ),
    );
  }
}

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController secretController = TextEditingController();

  String aliasText = "";
  String secretText = "";

  bool internDebug = true; //put true for debug messages in console
  bool speCharSwitch = true;

  bool numberSwitch = true;
  bool lettersSwitch = true;
  bool capLettersSwitch = true;

  bool aliasValidator = false;
  bool secretValidator = false;

  int currentSliderValue = 32;

  String replaceChars(String str) {
    str = str.replaceAll("0f", "_#");
    str = str.replaceAll("1e", "#*");
    str = str.replaceAll("2d", "^&");
    str = str.replaceAll("3c", "}^");
    str = str.replaceAll("4b", "[£");
    str = str.replaceAll("5a", ";@");
    str = str.replaceAll("69", ",(");
    str = str.replaceAll("78", "~%");
    str = str.replaceAll("87", "=&");
    str = str.replaceAll("96", "%<");
    str = str.replaceAll("a5", "*>");
    str = str.replaceAll("b4", "*/");
    str = str.replaceAll("c3", "@,");
    str = str.replaceAll("d2", ").");
    str = str.replaceAll("e1", "=!");
    str = str.replaceAll("f0", "})");
    str = str.replaceAll("11", "]-");
    str = str.replaceAll("22", "&]");

    str = str.replaceAll("33", "&#");
    str = str.replaceAll("44", "#*");
    str = str.replaceAll("55", "+&");
    str = str.replaceAll("66", "-^");
    str = str.replaceAll("77", "/£");
    str = str.replaceAll("88", "*@");
    str = str.replaceAll("99", "=(");
    str = str.replaceAll("00", "^%");
    str = str.replaceAll("Aa", "£ç");
    str = str.replaceAll("Bb", "\$¢");
    str = str.replaceAll("Cc", "|>");
    str = str.replaceAll("Dd", "\\/");
    str = str.replaceAll("Ee", "\$");
    str = str.replaceAll("Ff", "\".");
    str = str.replaceAll("ab", "'!");
    str = str.replaceAll("cd", "!)");
    str = str.replaceAll("ef", "&-");
    str = str.replaceAll("gh", ")]");

    str = str.replaceAll("01", "_#");
    str = str.replaceAll("12", "%*");
    str = str.replaceAll("23", "_&");
    str = str.replaceAll("34", "+^");
    str = str.replaceAll("45", "£\$");
    str = str.replaceAll("56", "@^");
    str = str.replaceAll("67", "(]");
    str = str.replaceAll("78", "%§");
    str = str.replaceAll("89", "§[");
    str = str.replaceAll("9a", "<-");
    str = str.replaceAll("ab", ">/");
    str = str.replaceAll("bc", "/%");
    str = str.replaceAll("cd", ",@");
    str = str.replaceAll("de", ".*");
    str = str.replaceAll("ef", "!#");
    str = str.replaceAll("AB", ")(");
    str = str.replaceAll("BC", "-}");
    str = str.replaceAll("CD", "]%");

    str = str.replaceAll("DE", "#_");
    str = str.replaceAll("EF", "*+");
    str = str.replaceAll("FG", "&<");

    return str;
  }

//Numeric character control variables #beginning

  String removeNumbersWithLetters(String str) {
    str = str.replaceAll("40", "Yg");
    str = str.replaceAll("39", "Xh");
    str = str.replaceAll("38", "Wi");
    str = str.replaceAll("37", "Vj");
    str = str.replaceAll("36", "Uk");
    str = str.replaceAll("35", "Tl");
    str = str.replaceAll("34", "Sm");
    str = str.replaceAll("33", "Rn");
    str = str.replaceAll("32", "Qo");
    str = str.replaceAll("31", "Pp");
    str = str.replaceAll("30", "Or");
    str = str.replaceAll("29", "Ns");
    str = str.replaceAll("28", "Mt");
    str = str.replaceAll("27", "Lu");
    str = str.replaceAll("26", "Kv");
    str = str.replaceAll("25", "Jw");
    str = str.replaceAll("24", "Ix");
    str = str.replaceAll("23", "Hy");
    str = str.replaceAll("22", "gz");
    str = str.replaceAll("21", "Gy");
    str = str.replaceAll("20", "Hz");
    str = str.replaceAll("19", "Iz");
    str = str.replaceAll("18", "Jy");
    str = str.replaceAll("17", "Lx");
    str = str.replaceAll("16", "Mw");
    str = str.replaceAll("15", "Nv");
    str = str.replaceAll("14", "Ou");
    str = str.replaceAll("13", "Pt");
    str = str.replaceAll("12", "Qr");
    str = str.replaceAll("11", "Rs");
    str = str.replaceAll("10", "Sq");
    str = str.replaceAll("9", "p");
    str = str.replaceAll("8", "o");
    str = str.replaceAll("7", "V");
    str = str.replaceAll("6", "m");
    str = str.replaceAll("5", "l");
    str = str.replaceAll("4", "Y");
    str = str.replaceAll("3", "Z");
    str = str.replaceAll("2", "I");
    str = str.replaceAll("1", "H");
    str = str.replaceAll("0", "G");

    return str;
  }

  String removeNumbersWithSpecChar(String str) {
    str = str.replaceAll("0", ">");
    str = str.replaceAll("9", "<");
    str = str.replaceAll("8", "[");
    str = str.replaceAll("7", ")");
    str = str.replaceAll("6", "+");
    str = str.replaceAll("5", "_");
    str = str.replaceAll("4", "@");
    str = str.replaceAll("3", "%");
    str = str.replaceAll("2", "&");
    str = str.replaceAll("1", "!");

    return str;
  }

//Numeric character control variables #end
  String replaceLetters(String str) {
    str = str.replaceAll("a", "0");
    str = str.replaceAll("b", "7");
    str = str.replaceAll("c", "2");
    str = str.replaceAll("d", "3");
    str = str.replaceAll("e", "5");
    str = str.replaceAll("f", "1");
    str = str.replaceAll("g", "4");
    str = str.replaceAll("h", "8");
    str = str.replaceAll("i", "1");
    str = str.replaceAll("j", "4");
    str = str.replaceAll("k", "5");
    str = str.replaceAll("l", "6");
    str = str.replaceAll("m", "0");
    str = str.replaceAll("n", "7");
    str = str.replaceAll("o", "2");
    str = str.replaceAll("p", "3");
    str = str.replaceAll("q", "5");
    str = str.replaceAll("r", "1");
    str = str.replaceAll("s", "4");
    str = str.replaceAll("t", "8");
    str = str.replaceAll("u", "3");
    str = str.replaceAll("v", "5");
    str = str.replaceAll("w", "7");
    str = str.replaceAll("x", "1");
    str = str.replaceAll("y", "0");
    str = str.replaceAll("z", "7");
    str = str.replaceAll("A", "2");
    str = str.replaceAll("B", "3");
    str = str.replaceAll("C", "5");
    str = str.replaceAll("D", "1");
    str = str.replaceAll("E", "4");
    str = str.replaceAll("F", "8");
    str = str.replaceAll("G", "6");
    str = str.replaceAll("H", "7");
    str = str.replaceAll("I", "8");
    str = str.replaceAll("J", "0");
    str = str.replaceAll("K", "0");
    str = str.replaceAll("L", "7");
    str = str.replaceAll("M", "2");
    str = str.replaceAll("N", "3");
    str = str.replaceAll("O", "5");
    str = str.replaceAll("P", "1");
    str = str.replaceAll("Q", "4");
    str = str.replaceAll("R", "8");
    str = str.replaceAll("S", "3");
    str = str.replaceAll("T", "5");
    str = str.replaceAll("U", "7");
    str = str.replaceAll("V", "2");
    str = str.replaceAll("W", "4");
    str = str.replaceAll("X", "6");
    str = str.replaceAll("Y", "4");
    str = str.replaceAll("Z", "9");
    return str;
  }

  String camelCase(String str) {
    String result = "";
    for (int i = 0; i < str.length; i++) {
      if (i % 2 == 0) {
        result += str[i].toUpperCase();
      } else {
        result += str[i].toLowerCase();
      }
    }
    return result;
  }

  bool hasUppercase(String str) {
    return RegExp(r'[A-Z]').hasMatch(str);
  }

  bool hasLowerAndUpperCase(String str) {
    // Checks if the string contains at least one lowercase letter and one uppercase letter
    return RegExp(r'[a-z]').hasMatch(str) && RegExp(r'[A-Z]').hasMatch(str);
  }

  bool hasLetters(String str) {
    // Checks if the string contains at least one letter
    return str.contains(RegExp(r'[a-zA-Z]'));
  }

  int findFirstLetterPosition(String str) {
// Find the position of the first letter in the string
    //debug purposes
    if (internDebug == true) {
      print("findFirstLetterPosition");
      print("${str.length}    $currentSliderValue");
    }
    if (str.length.toInt() > currentSliderValue.toInt()) {
      str = str.substring(0, 128);
      //debug purposes
      if (internDebug == true) {
        print("Search for first capital letter");
        print(str);
        print("1 $str.length");
      }
    }

    return str.indexOf(RegExp(r'[a-zA-Z]'));
  }

  String capitalizeFirstAndLast(String str) {
    List<String> characters = str.split("");
    bool firstLetterFound = false;

    for (int i = 0; i < characters.length; i++) {
      if (firstLetterFound == false) {
        if (characters[i].toUpperCase() != characters[i].toLowerCase()) {
          characters[i] = characters[i].toUpperCase();
          firstLetterFound = true;
        }
      } else {
        if (characters[i].toUpperCase() != characters[i].toLowerCase()) {
          characters[i] = characters[i].toLowerCase();
        }
      }
    }

    String restructuredText = characters.join();
    return restructuredText;
  }

//password generation #beginning
  String pwValue(String aliasStr, String secretStr) {
    String password = '';

    password = "#$aliasStr#$secretStr#";
    var bytes = utf8.encode(password);
    var hash = sha512.convert(bytes);

    password = hash.toString();
//debug purposes
    if (internDebug == true) {
      print("sha512: ");
      print("2 ${password.length}");
      print(password);
    }

    if (lettersSwitch == false) {
      password = replaceLetters(password);
    }
//debug purposes
    if (internDebug == true) {
      print("3 ${password.length}");
      print("remove letters:");
      print(password);
    }
    if (speCharSwitch == true) {
      password = replaceChars(password);
    }
    //debug purposes
    if (internDebug == true) {
      print("4 ${password.length}");
      print("insert special characters:");
      print(password);
    }
    if (numberSwitch == false) {
      if (lettersSwitch == true) {
        password = removeNumbersWithLetters(password);

        //debug purposes
        if (internDebug == true) {
          print("5 ${password.length}");
          print("change number with letters ^^: ");
        }
      } else {
        password = removeNumbersWithSpecChar(password);

        //debug purposes
        if (internDebug == true) {
          print("6 ${password.length}");
          print("change numbers with special characters  ^^: ");
        }
      }
    }
    if (internDebug == true) {
      //debug purposes
      print("7 ${password.length}");
      print(password);
    }
    if (capLettersSwitch == true) {
      password = camelCase(password);
      bool containsUppercase = hasUppercase(password);
      if (containsUppercase == false) {
        password = capitalizeFirstAndLast(password);
      }
    }
    if (internDebug == true) {
      //debug purposes
      print("8 ${password.length}");
      print("upper case and lower case");
      print(password);
    }
    if (hasLowerAndUpperCase(password) == false &&
        hasLetters(password) == true) {
      if (internDebug == true) {
        //debug purposes
        print(
            "hasLowerAndUpperCase(password) == false hasLetters(password) == true)");
        print("currentSliderValue.toInt()");
        print("findFirstLetterPosition(password)");
        print("$currentSliderValue       ${findFirstLetterPosition(password)}");
      }
    }

    if (capLettersSwitch == false) {
      password = password.toLowerCase();
    }

    password = password.substring(0, currentSliderValue.toInt());

//debug purposes
    if (internDebug == true) {
      print("10 ${password.length}");
      print("senha final:");
      print(password);
    }
    return password;
  }

  int securityLevel(int secPwValue) {
    int internSecurityLevel = 0;

    if (speCharSwitch == true) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (numberSwitch == true) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (lettersSwitch == true) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (capLettersSwitch == true) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (secPwValue > 10) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (secPwValue > 16) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (secPwValue > 32) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (secPwValue > 64) {
      internSecurityLevel = internSecurityLevel + 1;
    }
    if (secPwValue > 100) {
      internSecurityLevel = internSecurityLevel + 1;
    }

    return internSecurityLevel;
  }

  //print("$aliasValidator     $secretValidator");
  String textNoPass() {
    if (aliasText != "" || secretText != "") {
      return pwValue(aliasText, secretText);
    }
    return "Please type Alias or Secret!";
  }

  int securityNoPass() {
    if (aliasText != "" || secretText != "") {
      return securityLevel(pwValue(aliasText, secretText).toString().length);
    } else {
      return 0;
    }
  }

  double newTextSize(var value) {
    double textDynamicSize = 0;
    if (aliasValidator == false && secretValidator == false) {
      return 24;
    }

    if (value == null) {
      return 50;
    }
    if (value.toString().length > 115) {
      textDynamicSize = 24;
    }
    if (value.toString().length > 81 && value.toString().length <= 115) {
      textDynamicSize = 28;
    }
    if (value.toString().length > 68 && value.toString().length <= 81) {
      textDynamicSize = 34;
    }
    if (value.toString().length > 43 && value.toString().length <= 68) {
      textDynamicSize = 36;
    }
    if (value.toString().length >= 16 && value.toString().length <= 43) {
      textDynamicSize = 43;
    }
    if (value.toString().length == 15) {
      textDynamicSize = 46;
    }
    if (value.toString().length == 14) {
      textDynamicSize = 49;
    }
    if (value.toString().length == 13) {
      textDynamicSize = 53;
    }
    if (value.toString().length == 12) {
      textDynamicSize = 57;
    }
    if (value.toString().length == 11) {
      textDynamicSize = 63;
    }
    if (value.toString().length == 10) {
      textDynamicSize = 69;
    }
    if (value.toString().length == 9) {
      textDynamicSize = 77;
    }
    if (value.toString().length == 8) {
      textDynamicSize = 87;
    }
    if (value.toString().length == 7) {
      textDynamicSize = 99;
    }
    if (value.toString().length == 6) {
      textDynamicSize = 116;
      print(textDynamicSize);
    }

    return textDynamicSize;
  }

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            // padding: const EdgeInsets.symmetric(vertical: smallSpacing),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: widthConstraint),
                  // Tapping within the a component card should request focus
                  // for that component's children.
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
                          padding: const EdgeInsets.fromLTRB(16, 5, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Type user, services or whatever other word',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 0.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(smallSpacing),
                                  child: TextField(
                                    //controller: aliasController,
                                    onChanged: (String value) {
                                      if (value.isEmpty || value == "") {
                                        aliasValidator = false;
                                        setState(() => aliasText = value);
                                      } else {
                                        aliasValidator = true;
                                        setState(() => aliasText = value);
                                      }
                                    },
                                    enabled: speCharSwitch == false &&
                                            numberSwitch == false &&
                                            lettersSwitch == false
                                        ? false
                                        : true,
                                    decoration: const InputDecoration(
                                      labelText: 'Alias *',
                                      hintText: "Enter an alias",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(smallSpacing),
                                  child: TextField(
                                    controller: secretController,
                                    onChanged: (String value) {
                                      if (value.isEmpty || value == "") {
                                        secretValidator = false;
                                        setState(() => secretText = value);
                                      } else {
                                        secretValidator = true;
                                        setState(() => secretText = value);
                                      }
                                    },
                                    enabled: speCharSwitch == false &&
                                            numberSwitch == false &&
                                            lettersSwitch == false
                                        ? false
                                        : true,
                                    decoration: const InputDecoration(
                                      labelText: 'Secret *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            // padding: const EdgeInsets.symmetric(vertical: smallSpacing),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints.tightFor(width: widthConstraint),
                  // Tapping within the a component card should request focus
                  // for that component's children.
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      aliasValidator == false &&
                                              secretValidator == false
                                          ? "Password length: 0 characters"
                                          : "Password length: ${currentSliderValue.round().toString()} characters")
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 0.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(6, 0, 0, 6),
                                      child: Card(
                                        color: securityNoPass() == 0
                                            ? const Color(0xffBF2600)
                                            : securityNoPass() == 1
                                                ? Colors.red
                                                : securityNoPass() == 2
                                                    ? Colors
                                                        .deepOrangeAccent[400]
                                                    : securityNoPass() == 3
                                                        ? Colors
                                                            .orangeAccent[400]
                                                        : securityNoPass() == 4
                                                            ? Colors.amber[400]
                                                            : securityNoPass() ==
                                                                    5
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    222,
                                                                    3)
                                                                : securityNoPass() ==
                                                                        6
                                                                    ? Colors
                                                                        .yellow
                                                                    : securityNoPass() ==
                                                                            7
                                                                        ? const Color(
                                                                            0xffd0df00)
                                                                        : securityNoPass() ==
                                                                                8
                                                                            ? const Color.fromARGB(
                                                                                255,
                                                                                54,
                                                                                179,
                                                                                126)
                                                                            : securityNoPass() == 9
                                                                                ? const Color.fromARGB(255, 0, 102, 68)
                                                                                : null,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 200,
                                              child: Center(
                                                child: ListTile(
                                                  title: const Text(
                                                    '',
                                                    style: TextStyle(
                                                      fontSize: 0,
                                                    ),
                                                  ),
                                                  subtitle: Text(textNoPass(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: newTextSize(
                                                            pwValue(aliasText,
                                                                secretText)),
                                                        fontFamily:
                                                            'ShareTechMono',
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: ElevatedButton.icon(
                                                      onPressed: aliasValidator ==
                                                                  false &&
                                                              secretValidator ==
                                                                  false
                                                          ? null
                                                          : () => Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      textNoPass())),
                                                      icon: const Icon(
                                                        Icons.copy,
                                                      ),
                                                      label:
                                                          const Text('Copy')),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          ),
          Padding(
            // padding: const EdgeInsets.symmetric(vertical: smallSpacing),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: widthConstraint),
                        // Tapping within the a component card should request focus
                        // for that component's children.
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 5, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Password characters:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 0.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Expanded(
                                                flex: 2,
                                                child: Slider(
                                                    value: currentSliderValue
                                                        .round()
                                                        .toDouble(),
                                                    min: 6,
                                                    max: 128,
                                                    onChanged: speCharSwitch ==
                                                                false &&
                                                            numberSwitch ==
                                                                false &&
                                                            lettersSwitch ==
                                                                false
                                                        ? null
                                                        : aliasValidator ==
                                                                    false &&
                                                                secretValidator ==
                                                                    false
                                                            ? null
                                                            : (double value) =>
                                                                {
                                                                  setState(() =>
                                                                      currentSliderValue =
                                                                          value
                                                                              .toInt())
                                                                }))
                                          ]),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: SwitchListTile(
                                                  secondary: const Icon(
                                                    Icons.attach_money_outlined,
                                                    size: 35,
                                                  ),
                                                  title: const Text(
                                                    'Special Characters',
                                                  ),
                                                  subtitle: Text(
                                                      "$aliasValidator @#% characters into your password $secretValidator",
                                                      style: const TextStyle(
                                                          fontSize: 12)),
                                                  value: speCharSwitch,
                                                  onChanged:
                                                      aliasValidator == false &&
                                                              secretValidator ==
                                                                  false
                                                          ? null
                                                          : (bool value) {
                                                              setState(() {
                                                                speCharSwitch =
                                                                    value;
                                                              });
                                                            },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: SwitchListTile(
                                                  secondary: const Icon(
                                                    Icons.onetwothree_outlined,
                                                    size: 35,
                                                  ),
                                                  title: const Text(
                                                    'Numbers',
                                                  ),
                                                  subtitle: const Text(
                                                      "Numbers into your password",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  value: numberSwitch,
                                                  onChanged:
                                                      aliasValidator == false &&
                                                              secretValidator ==
                                                                  false
                                                          ? null
                                                          : (bool value) {
                                                              setState(() {
                                                                numberSwitch =
                                                                    value;
                                                              });
                                                            },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: SwitchListTile(
                                                  secondary: const Icon(
                                                    Icons.abc_outlined,
                                                    size: 35,
                                                  ),
                                                  title: const Text(
                                                    'Letters',
                                                  ),
                                                  subtitle: const Text(
                                                      "Letters into your password",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  value: lettersSwitch,
                                                  onChanged:
                                                      aliasValidator == false &&
                                                              secretValidator ==
                                                                  false
                                                          ? null
                                                          : (bool value) {
                                                              setState(() {
                                                                lettersSwitch =
                                                                    value;
                                                                capLettersSwitch =
                                                                    false;
                                                              });
                                                            },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 0, 0),
                                                  child: SwitchListTile(
                                                      secondary: const Icon(
                                                        Icons
                                                            .format_size_outlined,
                                                        size: 35,
                                                      ),
                                                      title: const Text(
                                                        'Capital letters',
                                                      ),
                                                      subtitle: const Text(
                                                          "Some capital letters into your password",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      value: capLettersSwitch,
                                                      onChanged: aliasValidator ==
                                                                  false &&
                                                              secretValidator ==
                                                                  false
                                                          ? null
                                                          : lettersSwitch ==
                                                                  false
                                                              ? null
                                                              : (bool value) {
                                                                  setState(() {
                                                                    capLettersSwitch =
                                                                        value;
                                                                  });
                                                                }),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//components

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.password_outlined),
    label: 'Generator',
    selectedIcon: Icon(Icons.password),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.settings_outlined),
    label: 'Settings',
    selectedIcon: Icon(Icons.settings),
  ),
];

class NavigationBars extends StatefulWidget {
  const NavigationBars({
    super.key,
    this.onSelectItem,
    required this.selectedIndex,
  });

  final void Function(int)? onSelectItem;
  final int selectedIndex;

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    // App NavigationBar should get first focus.
    Widget navigationBar = Focus(
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: appBarDestinations,
      ),
    );

    ComponentDecoration(child: navigationBar);
    return navigationBar;
  }
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
