import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'dart:core';

import 'globals.dart';
import 'home.dart';
// import 'settings/privacyandtos.dart';

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
      return Container(
        decoration: BoxDecoration(
          color: isLinux && !isWeb
              ? context.isDarkMode
                  ? appBgDark
                  : appBgLight
              : null,
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
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            color: isLinux && !isWeb
                ? context.isDarkMode
                    ? appBgDark
                    : appBgLight
                : null,
            child: const PasswordGeneratorPage(),
          ),
        ),
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

  bool internDebug = false; //put true for debug messages in console
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

    //print(password.substring(0, currentSliderValue));

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

  String textNoPass() {
    // print('textnopass 1');
    if (aliasText != "" || secretText != "") {
      // print('textnopass 2');
      return pwValue(aliasText, secretText);
    }

    // print('textnopass 3');
    return " Please type Alias or Secret!\n";
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
      return 19;
    }

    if (value == null) {
      return 50;
    }
    if (value.toString().length > 120) {
      textDynamicSize = 16;
    }

    if (value.toString().length > 100 && value.toString().length <= 120) {
      textDynamicSize = 18;
    }
    if (value.toString().length > 66 && value.toString().length <= 100) {
      textDynamicSize = 20;
    }
    if (value.toString().length > 58 && value.toString().length <= 66) {
      textDynamicSize = 25;
    }
    if (value.toString().length > 52 && value.toString().length <= 58) {
      textDynamicSize = 28;
    }
    if (value.toString().length > 29 && value.toString().length <= 52) {
      textDynamicSize = 32;
    }
    if (value.toString().length > 26 && value.toString().length <= 29) {
      textDynamicSize = 36;
    }
    if (value.toString().length > 20 && value.toString().length <= 26) {
      textDynamicSize = 43;
    }
    if (value.toString().length > 9 && value.toString().length <= 20) {
      textDynamicSize = 50;
    }
    if (value.toString().length == 8 || value.toString().length == 9) {
      textDynamicSize = 68;
    }
    if (value.toString().length < 8) {
      textDynamicSize = 70;
    }

    return textDynamicSize;
  }

  bool alertDialogShown = false; // Variável de controle

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showCustomAlertDialog(); // Chama a função para exibir o AlertDialog
    // });
  }

  // void showCustomAlertDialog() async {
  //   if (!alertDialogShown) {
  //     await CustomAlertDialog.show(context);
  //     setState(() {
  //       alertDialogShown = true; // Marca que o AlertDialog foi mostrado
  //     });
  //   }
  // }

  bool aliasObscure = false;
  bool secretObscure = false;

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics:
                const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              children: [
                CardCreator(
                  title: 'Type user, services or whatever other word',
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(smallSpacing),
                              child: TextField(
                                obscureText: aliasObscure,
                                style: const TextStyle(
                                  fontFamily: 'Ubuntu',
                                  decorationThickness: 0,
                                ),
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
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      aliasObscure == true
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        aliasObscure = !aliasObscure;
                                      });
                                    },
                                  ),
                                  labelText: 'Alias *',
                                  hintText: "Enter an alias",
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(smallSpacing),
                              child: TextField(
                                obscureText: true,
                                style: const TextStyle(
                                  fontFamily: 'Ubuntu',
                                  decorationThickness: 0,
                                ),
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
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      secretObscure == true
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        secretObscure = !secretObscure;
                                      });
                                    },
                                  ),
                                  labelText: 'Secret *',
                                  filled: true,
                                  hintText: "Enter a secret",
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Focus(
                      focusNode: focusNode,
                      canRequestFocus: true,
                      child: GestureDetector(
                        onTapDown: (_) {
                          focusNode.requestFocus();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: CardCreator(
                          title: aliasValidator == false &&
                                  secretValidator == false
                              ? "Password length: 0 characters"
                              : "Password length: ${currentSliderValue.round().toString()} characters",
                          child: Column(
                            children: [
                              ClipPath(
                                // mainAxisSize: MainAxisSize.max,
                                clipper: const ShapeBorderClipper(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                                // mainAxisSize: MainAxisSize.max,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: passwordCardColor(
                                              securityNoPass(),
                                              context,
                                              context.isDarkMode),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 150,
                                              child: ListTile(
                                                title: const Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 0,
                                                  ),
                                                ),
                                                subtitle: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  child: Text(textNoPass(),
                                                      textAlign: aliasText ==
                                                                  "" &&
                                                              secretText == ""
                                                          ? TextAlign.center
                                                          : TextAlign.justify,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        color: aliasText ==
                                                                    "" &&
                                                                secretText == ""
                                                            ? Colors.yellow
                                                            : Colors.white,
                                                        fontSize: newTextSize(
                                                            pwValue(aliasText,
                                                                secretText)),
                                                        fontFamily:
                                                            'ShareTechMono',
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                heightFactor: 1,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.copy,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Copy'),
                                                    ],
                                                  ),
                                                  onPressed: () => Clipboard
                                                      .setData(ClipboardData(
                                                          text: textNoPass())),
                                                  //  temporaryFunction(),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CardCreator(
                            title: 'Password characters:',
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 0.0,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: Slider(
                                                        value:
                                                            currentSliderValue
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
                                                                : (double
                                                                        value) =>
                                                                    {
                                                                      setState(() =>
                                                                          currentSliderValue =
                                                                              value.toInt())
                                                                    }))
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 2,
                                                  child: SwitchListTile(
                                                    secondary: const Icon(
                                                      Icons
                                                          .attach_money_outlined,
                                                      size: 35,
                                                    ),
                                                    title: const Text(
                                                      'Special Characters',
                                                    ),
                                                    subtitle: const Text(
                                                        "@#% characters into your password",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    value: speCharSwitch,
                                                    onChanged: aliasValidator ==
                                                                false &&
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
                                                      Icons
                                                          .onetwothree_outlined,
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
                                                    onChanged: aliasValidator ==
                                                                false &&
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
                                                    onChanged: aliasValidator ==
                                                                false &&
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(20, 0, 0, 0),
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
                                                                    setState(
                                                                        () {
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
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
