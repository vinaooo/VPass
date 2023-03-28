// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:core';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:sensitive_clipboard/sensitive_clipboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double narrowScreenWidthThreshold = 450;
const double mediumWidthBreakpoint = 800;
const double largeWidthBreakpoint = 1200;
const double transitionLength = 500;
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
  pink('Pink', Colors.pink);

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
  String localThemeBrightness = '';
  bool appStartedNow = false;
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;

  bool isSaved = false;
  String themeBrightness = '';

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      print('handleBrightnessChange:     $useLightMode');
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

  @override
  void initState() {
    super.initState();
    savedConfigs();
  }

  void savedConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var _themeBrightness = prefs.getString('themeBrightness');
    if (_themeBrightness != null) {
      setState(() {
        isSaved = true;
        print('conseguiu ler');
        themeBrightness = _themeBrightness.toString();
        print(themeBrightness);
      });
    }
  }

  Future<void> notSaved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeBrightness', '');

    setState(() {
      themeBrightness = '';
      isSaved = false;
    });
  }

//para fazer o modo do sistema eu tenho que salvar um terceiro
//modo em prefs.setString e então fazer isso ser igual ao valor
//do sistema que está em
//bool -> SchedulerBinding .instance.platformDispatcher.platformBrightness == Brightness.light;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return SchedulerBinding //SystemMode
                .instance
                .platformDispatcher
                .platformBrightness ==
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
      // isSaved == true && themeBrightness == '1' //ainda nao tenho certeza
      //     ? ThemeMode.light
      //     : isSaved == true && themeBrightness == '0'
      //         ? ThemeMode.dark
      //         : themeMode,
      //themeMode,
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
        useLightMode: 
        // isSaved == true && themeBrightness == '1'
        //     ? true
        //     : isSaved == true && themeBrightness == '0'
        //         ? false
        //         : useLightMode,

                useLightMode,
                useMaterial3
                : useMaterial3,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return NavigationTransition(
            scaffoldKey: scaffoldKey, //inicio?
            animationController: controller,
            railAnimation: railAnimation,
            appBar: Platform.isAndroid == true
                ? AppBar(
                    title: const Text('VPass'),
                    centerTitle: true,
                  )
                : null,
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
        });
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
  final appBar;
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
  // @override
  // void initState() {
  //   super.initState();
  //   savedConfigs();
  // }

  // bool isSaved = false;
  String saveThemeBrightness = '';
  String bsThemeBrightness = '';

  Future<void> saveConfigs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeBrightness', saveThemeBrightness);
    setState(() {
      bsThemeBrightness = saveThemeBrightness;
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
            saveThemeBrightness = '1';
            saveConfigs();
          }),
      IconButton(
        //copia aqui
        icon: const Icon(Icons.dark_mode),
        onPressed: () {
          widget.handleBrightnessChange(false);
          saveThemeBrightness = '0';
          saveConfigs();
        },
      ),
      IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                content: const Text(
                    'Sorry this is not implemented, maybe never will'),
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
                                height: 121,
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

  String pwValue(String aliasStr, String secretStr) {
    String password = "";

    String vsha512(String entrada) {
      var bytes = utf8.encode(entrada);
      var digest = sha512.convert(bytes);
      var hexString = hex.encode(digest.bytes);
      String bigHexString =
          hexString.toString() + hexString.toString().split('').reversed.join();
      bigHexString = bigHexString.split('').join() + bigHexString;
      bigHexString = bigHexString.split('').join() + bigHexString;
      bigHexString = bigHexString.split('').join() + bigHexString;
      bigHexString = bigHexString.split('').join() + bigHexString;
      return bigHexString;
    }

    String encodeHash(String hash) {
      var bytes = hex.decode(hash);
      var allowedChars = '''
ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzz0123456789!@#\$%^&*()_+-=[]{};''';
      var encodedChars = bytes
          .map((byte) => allowedChars.codeUnitAt(byte % allowedChars.length));
      return String.fromCharCodes(encodedChars);
    }

    String removeDuplicateChars(String str) {
      StringBuffer sb = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i == 0 || str[i] != str[i - 1]) {
          sb.write(str[i]);
        }
      }
      return sb.toString();
    }

    StringBuffer sb = StringBuffer();

    var hash = vsha512('!$aliasText@$secretText#');
    var encodedHash = encodeHash(hash);

    var reversedHash = encodedHash.split('').reversed.join();

    int minLength = encodedHash.length < reversedHash.length
        ? encodedHash.length
        : reversedHash.length;
    for (int i = 0; i < minLength; i++) {
      sb.write(encodedHash[i]);
      sb.write(reversedHash[i]);
    }

    if (encodedHash.length > minLength) {
      sb.write(encodedHash.substring(minLength));
    } else if (reversedHash.length > minLength) {
      sb.write(reversedHash.substring(minLength));
    }

    password = removeDuplicateChars(sb.toString());

    String removeNumbers(String str) {
      return str.replaceAll(RegExp(r'[0-9]'), '');
    }

    String removeLetter(String str) {
      return str.replaceAll(RegExp(r'[a-zA-Z]'), '');
    }

    String removeSpecChar(String str) {
      return str.replaceAll(RegExp(r'[!@#\$%^&*()_+\-=\[\]{};]'), '');
    }

    if (lettersSwitch == false) password = removeLetter(password);
    if (numberSwitch == false) password = removeNumbers(password);
    if (speCharSwitch == false) password = removeSpecChar(password);
    if (capLettersSwitch == false) password = password.toLowerCase();

    print(password.substring(0, currentSliderValue));

    return password.substring(
        0, currentSliderValue); //mensagem do sem senha, ou sei la
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

  bool _loading = false;

  Future<void> copyToClipboard() async {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _loading = true);

    bool dataWasHiddenForAndroidAPI33;
    String text;

    try {
      dataWasHiddenForAndroidAPI33 = await SensitiveClipboard.copy(
        textNoPass(),
        hideContent: true,
      );
      text = 'Successfully copied to Clipboard!';
    } on PlatformException {
      text = 'Ops! Something went wrong.';
      dataWasHiddenForAndroidAPI33 = false;
    }

    if (!mounted) return;

    if (!dataWasHiddenForAndroidAPI33) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
    }

    setState(() => _loading = false);
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
                                    style:
                                        const TextStyle(fontFamily: 'Ubuntu'),
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
                                    style:
                                        const TextStyle(fontFamily: 'Ubuntu'),
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
                                                  child: ElevatedButton(
                                                    onPressed: _loading
                                                        ? null
                                                        : copyToClipboard,
                                                    child: const Text('Copy'),
                                                  ),
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
  void didUpdateWidget(covariant NavigationBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      selectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    // App NavigationBar should get first focus.
    Widget navigationBar = Focus(
      autofocus: true,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
          widget.onSelectItem!(index);
        },
        destinations: appBarDestinations,
      ),
    );

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
