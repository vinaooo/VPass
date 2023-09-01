import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pubspec.dart';
import 'version.dart';
import '../home.dart';

class VersionSection extends StatefulWidget {
  const VersionSection({super.key});

  @override
  State<VersionSection> createState() => _VersionSectionState();
}

class _VersionSectionState extends State<VersionSection> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String policyURL = 'https://vpass.techv.dev/privacy.html';
  String tosURL = 'https://vpass.techv.dev/tos.html';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb == true) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
            _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
            _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
            _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
            _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
              'Error:': 'Fuchsia platform isn\'t supported'
            },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'Security Patch: ': build.version.securityPatch,
      'SDK: ': build.version.sdkInt,
      'Version: ': build.version.release,
      'Incremental version: ': build.version.incremental,
      'Brand: ': build.brand,
      'Device: ': build.device,
      'Manufacturer: ': build.manufacturer,
      'Model: ': build.model,
      'Product: ': build.product,
      'Display Size: ':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'Display Width Pixels: ': build.displayMetrics.widthPx.toInt(),
      'Display Height Pixels: ': build.displayMetrics.heightPx.toInt(),
      'Display Width Inches: ':
          build.displayMetrics.widthInches.toStringAsFixed(2),
      'Display Height Inches: ':
          build.displayMetrics.heightInches.toStringAsFixed(2),
      'DPI: ': build.displayMetrics.xDpi.toInt(),
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name: ': data.name,
      'systemName: ': data.systemName,
      'systemVersion: ': data.systemVersion,
      'model: ': data.model,
      'localizedModel: ': data.localizedModel,
      'identifierForVendor: ': data.identifierForVendor,
      'isPhysicalDevice: ': data.isPhysicalDevice,
      'utsname.sysname: ': data.utsname.sysname,
      'utsname.nodename: ': data.utsname.nodename,
      'utsname.release: ': data.utsname.release,
      'utsname.version: ': data.utsname.version,
      'utsname.machine: ': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name: ': data.name,
      'version: ': data.version,
      'id: ': data.id,
      'prettyName: ': data.prettyName,
      'machineId: ': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName: ': describeEnum(data.browserName),
      'appCodeName: ': data.appCodeName,
      'appName: ': data.appName,
      'appVersion: ': data.appVersion,
      'platform: ': data.platform,
      'product: ': data.product,
      'productSub: ': data.productSub,
      'userAgent: ': data.userAgent,
      'vendor: ': data.vendor,
      'vendorSub: ': data.vendorSub,
      'hardwareConcurrency: ': data.hardwareConcurrency,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'arch: ': data.arch,
      'model: ': data.model,
      'kernelVersion: ': data.kernelVersion,
      'majorVersion: ': data.majorVersion,
      'minorVersion: ': data.minorVersion,
      'patchVersion: ': data.patchVersion,
      'osRelease: ': data.osRelease,
      'systemGUID: ': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'Version: ': data.productName,
      'Edition: ': data.editionId,
      'Build Number: ': data.buildNumber,
      'Build: ': data.buildLab,
      'Build Lab Ex: ': data.buildLabEx,
      'Display Version: ': data.displayVersion,
      'Id: ': data.productId,
      'Device Id: ': data.deviceId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return CardCreator(
      title: 'About',
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              const ListTile(
                title: Text('APP Version:'),
                subtitle: Text(Pubspec.versionFull),
                subtitleTextStyle: TextStyle(fontSize: 11),
                leading: Icon(Icons.info_outline),
                onTap: _showDialog,
              ),
              const ListTile(
                title: Text('Build Number:'),
                subtitle: Text(PackageInfoUtils.getInfo('Build number')),
                subtitleTextStyle: TextStyle(fontSize: 11),
                leading: Icon(Icons.pin_outlined),
              ),
              ListTile(
                title: const Text('System:'),
                subtitle: Text(Platform.operatingSystem[0].toUpperCase() +
                    Platform.operatingSystem.substring(1).toLowerCase()),
                subtitleTextStyle: const TextStyle(fontSize: 11),
                leading: const Icon(Icons.android),
                onTap: () => _showDeviceInfoDialog(context),
              ),
              const ListTile(
                title: Text('Store:'),
                // subtitle: Text(Pubspec.store),
                subtitleTextStyle: TextStyle(fontSize: 11),
                leading: Icon(Icons.store_mall_directory_outlined),
              ),
              ListTile(
                title: const Text('Privacy policy'),
                onTap: () => _launchURL(policyURL),
                leading: const Icon(Icons.privacy_tip_outlined),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                onTap: () => _launchURL(tosURL),
                leading: const Icon(Icons.security),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeviceInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _deviceData.keys.map(
              (String property) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        property,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${_deviceData[property]}',
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

_launchURL(linkUrl) async {
  final Uri url = Uri.parse(linkUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
