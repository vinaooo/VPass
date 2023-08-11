import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class CustomAlertDialog {
  static Future<void> show(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool privacyAccepted = prefs.getBool('privacyAccepted') ?? false;
    bool tosAccepted = prefs.getBool('tosAccepted') ?? false;

    bool shouldShowDialog = !(privacyAccepted && tosAccepted);

    if (shouldShowDialog) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext innerContext) {
          return _buildAlertDialog(innerContext, prefs);
        },
      );
    }
  }

  static Widget _buildAlertDialog(
      BuildContext context, SharedPreferences prefs) {
    bool privacyAccepted = prefs.getBool('privacyAccepted') ?? false;
    bool tosAccepted = prefs.getBool('tosAccepted') ?? false;

    const String policyURL = 'https://vpass.techv.dev/privacy.html';
    const String tosURL = 'https://vpass.techv.dev/tos.html';

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text(
            'Privacy Policy and Terms of Service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: isAndroid
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('I agree with the '),
                          InkWell(
                            onTap: () => _launchURL(policyURL),
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Text('I agree with the '),
                          InkWell(
                            onTap: () => _launchURL(policyURL),
                            child: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                value: privacyAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    privacyAccepted = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: isAndroid
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('I agree with the '),
                          InkWell(
                            onTap: () => _launchURL(tosURL),
                            child: const Text(
                              'Terms of Use',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Text('I agree with the '),
                          InkWell(
                            onTap: () => _launchURL(tosURL),
                            child: const Text(
                              'Terms of Service',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                value: tosAccepted,
                onChanged: (bool? value) {
                  setState(() {
                    tosAccepted = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog

                Future.delayed(Duration.zero, () {
                  SystemNavigator.pop();
                });
              },
              child: const Text('Reject'),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: (privacyAccepted && tosAccepted)
                  ? () async {
                      prefs.setBool('privacyAccepted', true);
                      prefs.setBool('tosAccepted', true);
                      Navigator.of(context).pop();
                      // Accept logic
                    }
                  : null,
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }
}

_launchURL(linkUrl) async {
  final Uri url = Uri.parse(linkUrl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
