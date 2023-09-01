// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// import 'pubspec.dart';

// class PackageInfoUtils {
//   static PackageInfo _packageInfo = PackageInfo(
//     appName: 'Unknown',
//     packageName: 'Unknown',
//     version: 'Unknown',
//     buildNumber: 'Unknown',
//     buildSignature: 'Unknown',
//     installerStore: 'Unknown',
//   );

//   static Future<void> initPackageInfo() async {
//     final info = await PackageInfo.fromPlatform();
//     _packageInfo = info;
//   }

//   static Widget infoTile(String title, String subtitle) {
//     return ListTile(
//       title: Text(title),
//       subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
//     );
//   }

//   static final Map<String, String Function()> _infoMap = {
//     'App name': () => _packageInfo.appName,
//     'Package name': () => _packageInfo.packageName,
//     'App version': () => Pubspec.version,
//     'Build number': () => _packageInfo.buildNumber,
//     'Build signature': () => _packageInfo.buildSignature,
//     'Installer store': () => _packageInfo.installerStore ?? 'Github',
//   };

//   static String getInfo(String title) {
//     final infoFunction = _infoMap[title];
//     return infoFunction != null ? infoFunction() : 'Unknown';
//   }
// }
