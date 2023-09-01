// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CustomAlertDialog {
//   static Future<void> show(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool privacyAndTosAccepted =
//         prefs.getBool('privacyAndTosAccepted') ?? false;

//     bool shouldShowDialog = !(privacyAndTosAccepted);

//     if (shouldShowDialog) {
//       // ignore: use_build_context_synchronously
//       showDialog(
//         context: context,
//         builder: (BuildContext innerContext) {
//           return _buildAlertDialog(innerContext, prefs);
//         },
//       );
//     }
//   }

//   static Widget _buildAlertDialog(
//       BuildContext context, SharedPreferences prefs) {
//     bool privacyAndTosAccepted = prefs.getBool('privacyAndTosAccepted') ?? true;

//     const String policyURL = 'https://vpass.techv.dev/privacy.html';
//     const String tosURL = 'https://vpass.techv.dev/tos.html';

//     return StatefulBuilder(
//       builder: (context, setState) {
//         return AlertDialog(
//           title: const Text(
//             'Privacy Policy and Terms of Service',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () => _launchURL(policyURL),
//                     child: const Text(
//                       'Privacy Policy',
//                       style: TextStyle(fontSize: 16, color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () => _launchURL(tosURL),
//                     child: const Text(
//                       'Terms of Service',
//                       style: TextStyle(fontSize: 16, color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               style: TextButton.styleFrom(backgroundColor: Colors.transparent),
//               onPressed: (privacyAndTosAccepted)
//                   ? () async {
//                       prefs.setBool('privacyAndTosAccepted', true);
//                       Navigator.of(context).pop();
//                       // Accept logic
//                     }
//                   : null,
//               child: const Text('Ok'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// _launchURL(linkUrl) async {
//   final Uri url = Uri.parse(linkUrl);
//   if (!await launchUrl(url)) {
//     throw Exception('Could not launch $url');
//   }
// }
