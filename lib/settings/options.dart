// import 'package:flutter/material.dart';

// import '../home.dart';

// class OptionsSection extends StatefulWidget {
//   const OptionsSection({super.key});

//   @override
//   State<OptionsSection> createState() => _OptionsSectionState();
// }

// class _OptionsSectionState extends State<OptionsSection> {
//   bool debugMode = true;
//   bool printScreen = false;

//   @override
//   Widget build(BuildContext context) {
//     return CardCreator(
//       title: 'Options',
//       child: Wrap(
//         alignment: WrapAlignment.spaceEvenly,
//         children: [
//           Column(
//             children: <Widget>[
//               const CheckboxListTile(
//                 title: Text('Hide password'),
//                 value: true,
//                 secondary: Icon(Icons.screenshot),
//                 onChanged: null,
//               ),
//               CheckboxListTile(
//                 title: const Text('Debug mode'),
//                 value: debugMode,
//                 secondary: const Icon(Icons.bug_report),
//                 onChanged: null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
