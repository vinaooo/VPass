
// class Tabs extends StatefulWidget {
//   const Tabs({super.key});

//   @override
//   State<Tabs> createState() => _TabsState();
// }

// class _TabsState extends State<Tabs> with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Tabs',
//       child: SizedBox(
//         height: 80,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: TabBar(
//               controller: _tabController,
//               tabs: const <Widget>[
//                 Tab(
//                   icon: Icon(Icons.videocam_outlined),
//                   text: 'Video',
//                   iconMargin: EdgeInsets.only(bottom: 0.0),
//                 ),
//                 Tab(
//                   icon: Icon(Icons.photo_outlined),
//                   text: 'Photos',
//                   iconMargin: EdgeInsets.only(bottom: 0.0),
//                 ),
//                 Tab(
//                   icon: Icon(Icons.audiotrack_sharp),
//                   text: 'Audio',
//                   iconMargin: EdgeInsets.only(bottom: 0.0),
//                 ),
//               ],
//             ),
//             // TODO: Showcase secondary tab bar https://github.com/flutter/flutter/issues/111962
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TopAppBars extends StatelessWidget {
//   const TopAppBars({super.key});

//   static final actions = [
//     IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
//     IconButton(icon: const Icon(Icons.event), onPressed: () {}),
//     IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Top app bars',
//       child: Column(
//         children: [
//           AppBar(
//             title: const Text('Center-aligned'),
//             leading: const BackButton(),
//             actions: [
//               IconButton(
//                 iconSize: 32,
//                 icon: const Icon(Icons.account_circle_outlined),
//                 onPressed: () {},
//               ),
//             ],
//             centerTitle: true,
//           ),
//           colDivider,
//           AppBar(
//             title: const Text('Small'),
//             leading: const BackButton(),
//             actions: actions,
//             centerTitle: false,
//           ),
//           colDivider,
//           SizedBox(
//             height: 100,
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar.medium(
//                   title: const Text('Medium'),
//                   leading: const BackButton(),
//                   actions: actions,
//                 ),
//                 const SliverFillRemaining(),
//               ],
//             ),
//           ),
//           colDivider,
//           SizedBox(
//             height: 130,
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar.large(
//                   title: const Text('Large'),
//                   leading: const BackButton(),
//                   actions: actions,
//                 ),
//                 const SliverFillRemaining(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Menus extends StatefulWidget {
//   const Menus({super.key});

//   @override
//   State<Menus> createState() => _MenusState();
// }

// class _MenusState extends State<Menus> {
//   final TextEditingController colorController = TextEditingController();
//   final TextEditingController iconController = TextEditingController();
//   IconLabel? selectedIcon = IconLabel.smile;
//   ColorLabel? selectedColor;

//   @override
//   Widget build(BuildContext context) {
//     final List<DropdownMenuEntry<ColorLabel>> colorEntries =
//         <DropdownMenuEntry<ColorLabel>>[];
//     for (final ColorLabel color in ColorLabel.values) {
//       colorEntries.add(DropdownMenuEntry<ColorLabel>(
//           value: color, label: color.label, enabled: color.label != 'Grey'));
//     }

//     final List<DropdownMenuEntry<IconLabel>> iconEntries =
//         <DropdownMenuEntry<IconLabel>>[];
//     for (final IconLabel icon in IconLabel.values) {
//       iconEntries
//           .add(DropdownMenuEntry<IconLabel>(value: icon, label: icon.label));
//     }

//     return ComponentDecoration(
//       label: 'Menus',
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ButtonAnchorExample(),
//               rowDivider,
//               IconButtonAnchorExample(),
//             ],
//           ),
//           colDivider,
//           Wrap(
//             alignment: WrapAlignment.spaceAround,
//             runAlignment: WrapAlignment.center,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             spacing: smallSpacing,
//             runSpacing: smallSpacing,
//             children: [
//               DropdownMenu<ColorLabel>(
//                 controller: colorController,
//                 label: const Text('Color'),
//                 enableFilter: true,
//                 dropdownMenuEntries: colorEntries,
//                 inputDecorationTheme: const InputDecorationTheme(filled: true),
//                 onSelected: (color) {
//                   setState(() {
//                     selectedColor = color;
//                   });
//                 },
//               ),
//               DropdownMenu<IconLabel>(
//                 initialSelection: IconLabel.smile,
//                 controller: iconController,
//                 leadingIcon: const Icon(Icons.search),
//                 label: const Text('Icon'),
//                 dropdownMenuEntries: iconEntries,
//                 onSelected: (icon) {
//                   setState(() {
//                     selectedIcon = icon;
//                   });
//                 },
//               ),
//               Icon(
//                 selectedIcon?.icon,
//                 color: selectedColor?.color ?? Colors.grey.withOpacity(0.5),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// enum ColorLabel {
//   blue('Blue', Colors.blue),
//   pink('Pink', Colors.pink),
//   green('Green', Colors.green),
//   yellow('Yellow', Colors.yellow),
//   grey('Grey', Colors.grey);

//   const ColorLabel(this.label, this.color);
//   final String label;
//   final Color color;
// }

// enum IconLabel {
//   smile('Smile', Icons.sentiment_satisfied_outlined),
//   cloud(
//     'Cloud',
//     Icons.cloud_outlined,
//   ),
//   brush('Brush', Icons.brush_outlined),
//   heart('Heart', Icons.favorite);

//   const IconLabel(this.label, this.icon);
//   final String label;
//   final IconData icon;
// }

// class IconToggleButtons extends StatefulWidget {
//   const IconToggleButtons({super.key});

//   @override
//   State<IconToggleButtons> createState() => _IconToggleButtonsState();
// }

// class _IconToggleButtonsState extends State<IconToggleButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return const ComponentDecoration(
//       label: 'Icon buttons',
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           Column(
//             // Standard IconButton
//             children: <Widget>[
//               IconToggleButton(
//                 isEnabled: true,
//                 tooltip: 'Standard',
//               ),
//               colDivider,
//               IconToggleButton(
//                 isEnabled: false,
//                 tooltip: 'Standard (disabled)',
//               ),
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               // Filled IconButton
//               IconToggleButton(
//                 isEnabled: true,
//                 tooltip: 'Filled',
//                 getDefaultStyle: enabledFilledButtonStyle,
//               ),
//               colDivider,
//               IconToggleButton(
//                 isEnabled: false,
//                 tooltip: 'Filled (disabled)',
//                 getDefaultStyle: disabledFilledButtonStyle,
//               ),
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               // Filled Tonal IconButton
//               IconToggleButton(
//                 isEnabled: true,
//                 tooltip: 'Filled tonal',
//                 getDefaultStyle: enabledFilledTonalButtonStyle,
//               ),
//               colDivider,
//               IconToggleButton(
//                 isEnabled: false,
//                 tooltip: 'Filled tonal (disabled)',
//                 getDefaultStyle: disabledFilledTonalButtonStyle,
//               ),
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               // Outlined IconButton
//               IconToggleButton(
//                 isEnabled: true,
//                 tooltip: 'Outlined',
//                 getDefaultStyle: enabledOutlinedButtonStyle,
//               ),
//               colDivider,
//               IconToggleButton(
//                 isEnabled: false,
//                 tooltip: 'Outlined (disabled)',
//                 getDefaultStyle: disabledOutlinedButtonStyle,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class IconToggleButton extends StatefulWidget {
//   const IconToggleButton({
//     required this.isEnabled,
//     required this.tooltip,
//     this.getDefaultStyle,
//     super.key,
//   });

//   final bool isEnabled;
//   final String tooltip;
//   final ButtonStyle? Function(bool, ColorScheme)? getDefaultStyle;

//   @override
//   State<IconToggleButton> createState() => _IconToggleButtonState();
// }

// class _IconToggleButtonState extends State<IconToggleButton> {
//   bool selected = false;

//   @override
//   Widget build(BuildContext context) {
//     final ColorScheme colors = Theme.of(context).colorScheme;
//     final VoidCallback? onPressed = widget.isEnabled
//         ? () {
//             setState(() {
//               selected = !selected;
//             });
//           }
//         : null;
//     ButtonStyle? style = widget.getDefaultStyle?.call(selected, colors);

//     return IconButton(
//       visualDensity: VisualDensity.standard,
//       isSelected: selected,
//       tooltip: widget.tooltip,
//       icon: const Icon(Icons.settings_outlined),
//       selectedIcon: const Icon(Icons.settings),
//       onPressed: onPressed,
//       style: style,
//     );
//   }
// }

// ButtonStyle enabledFilledButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     foregroundColor: selected ? colors.onPrimary : colors.primary,
//     backgroundColor: selected ? colors.primary : colors.surfaceVariant,
//     disabledForegroundColor: colors.onSurface.withOpacity(0.38),
//     disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
//     hoverColor: selected
//         ? colors.onPrimary.withOpacity(0.08)
//         : colors.primary.withOpacity(0.08),
//     focusColor: selected
//         ? colors.onPrimary.withOpacity(0.12)
//         : colors.primary.withOpacity(0.12),
//     highlightColor: selected
//         ? colors.onPrimary.withOpacity(0.12)
//         : colors.primary.withOpacity(0.12),
//   );
// }

// ButtonStyle disabledFilledButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     disabledForegroundColor: colors.onSurface.withOpacity(0.38),
//     disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
//   );
// }

// ButtonStyle enabledFilledTonalButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     foregroundColor:
//         selected ? colors.onSecondaryContainer : colors.onSurfaceVariant,
//     backgroundColor:
//         selected ? colors.secondaryContainer : colors.surfaceVariant,
//     hoverColor: selected
//         ? colors.onSecondaryContainer.withOpacity(0.08)
//         : colors.onSurfaceVariant.withOpacity(0.08),
//     focusColor: selected
//         ? colors.onSecondaryContainer.withOpacity(0.12)
//         : colors.onSurfaceVariant.withOpacity(0.12),
//     highlightColor: selected
//         ? colors.onSecondaryContainer.withOpacity(0.12)
//         : colors.onSurfaceVariant.withOpacity(0.12),
//   );
// }

// ButtonStyle disabledFilledTonalButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     disabledForegroundColor: colors.onSurface.withOpacity(0.38),
//     disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
//   );
// }

// ButtonStyle enabledOutlinedButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     backgroundColor: selected ? colors.inverseSurface : null,
//     hoverColor: selected
//         ? colors.onInverseSurface.withOpacity(0.08)
//         : colors.onSurfaceVariant.withOpacity(0.08),
//     focusColor: selected
//         ? colors.onInverseSurface.withOpacity(0.12)
//         : colors.onSurfaceVariant.withOpacity(0.12),
//     highlightColor: selected
//         ? colors.onInverseSurface.withOpacity(0.12)
//         : colors.onSurface.withOpacity(0.12),
//     side: BorderSide(color: colors.outline),
//   ).copyWith(
//     foregroundColor: MaterialStateProperty.resolveWith((states) {
//       if (states.contains(MaterialState.selected)) {
//         return colors.onInverseSurface;
//       }
//       if (states.contains(MaterialState.pressed)) {
//         return colors.onSurface;
//       }
//       return null;
//     }),
//   );
// }

// ButtonStyle disabledOutlinedButtonStyle(bool selected, ColorScheme colors) {
//   return IconButton.styleFrom(
//     disabledForegroundColor: colors.onSurface.withOpacity(0.38),
//     disabledBackgroundColor:
//         selected ? colors.onSurface.withOpacity(0.12) : null,
//     side: selected ? null : BorderSide(color: colors.outline.withOpacity(0.12)),
//   );
// }

// class Chips extends StatefulWidget {
//   const Chips({super.key});

//   @override
//   State<Chips> createState() => _ChipsState();
// }

// class _ChipsState extends State<Chips> {
//   bool isFiltered = true;

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Chips',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Wrap(
//             spacing: smallSpacing,
//             runSpacing: smallSpacing,
//             children: <Widget>[
//               ActionChip(
//                 label: const Text('Assist'),
//                 avatar: const Icon(Icons.event),
//                 onPressed: () {},
//               ),
//               FilterChip(
//                 label: const Text('Filter'),
//                 selected: isFiltered,
//                 onSelected: (selected) {
//                   setState(() => isFiltered = selected);
//                 },
//               ),
//               InputChip(
//                 label: const Text('Input'),
//                 onPressed: () {},
//                 onDeleted: () {},
//               ),
//               ActionChip(
//                 label: const Text('Suggestion'),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           colDivider,
//           Wrap(
//             spacing: smallSpacing,
//             runSpacing: smallSpacing,
//             children: <Widget>[
//               const ActionChip(
//                 label: Text('Assist'),
//                 avatar: Icon(Icons.event),
//               ),
//               FilterChip(
//                 label: const Text('Filter'),
//                 selected: isFiltered,
//                 onSelected: null,
//               ),
//               InputChip(
//                 label: const Text('Input'),
//                 onDeleted: () {},
//                 isEnabled: false,
//               ),
//               const ActionChip(
//                 label: Text('Suggestion'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SegmentedButtons extends StatelessWidget {
//   const SegmentedButtons({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ComponentDecoration(
//       label: 'Segmented buttons',
//       child: Column(
//         children: <Widget>[
//           SingleChoice(),
//           colDivider,
//           MultipleChoice(),
//         ],
//       ),
//     );
//   }
// }

// enum Calendar { day, week, month, year }

// class SingleChoice extends StatefulWidget {
//   const SingleChoice({super.key});

//   @override
//   State<SingleChoice> createState() => _SingleChoiceState();
// }

// class _SingleChoiceState extends State<SingleChoice> {
//   Calendar calendarView = Calendar.day;

//   @override
//   Widget build(BuildContext context) {
//     return SegmentedButton<Calendar>(
//       segments: const <ButtonSegment<Calendar>>[
//         ButtonSegment<Calendar>(
//             value: Calendar.day,
//             label: Text('Day'),
//             icon: Icon(Icons.calendar_view_day)),
//         ButtonSegment<Calendar>(
//             value: Calendar.week,
//             label: Text('Week'),
//             icon: Icon(Icons.calendar_view_week)),
//         ButtonSegment<Calendar>(
//             value: Calendar.month,
//             label: Text('Month'),
//             icon: Icon(Icons.calendar_view_month)),
//         ButtonSegment<Calendar>(
//             value: Calendar.year,
//             label: Text('Year'),
//             icon: Icon(Icons.calendar_today)),
//       ],
//       selected: <Calendar>{calendarView},
//       onSelectionChanged: (newSelection) {
//         setState(() {
//           // By default there is only a single segment that can be
//           // selected at one time, so its value is always the first
//           // item in the selected set.
//           calendarView = newSelection.first;
//         });
//       },
//     );
//   }
// }

// enum Sizes { extraSmall, small, medium, large, extraLarge }

// class MultipleChoice extends StatefulWidget {
//   const MultipleChoice({super.key});

//   @override
//   State<MultipleChoice> createState() => _MultipleChoiceState();
// }

// class _MultipleChoiceState extends State<MultipleChoice> {
//   Set<Sizes> selection = <Sizes>{Sizes.large, Sizes.extraLarge};

//   @override
//   Widget build(BuildContext context) {
//     return SegmentedButton<Sizes>(
//       segments: const <ButtonSegment<Sizes>>[
//         ButtonSegment<Sizes>(value: Sizes.extraSmall, label: Text('XS')),
//         ButtonSegment<Sizes>(value: Sizes.small, label: Text('S')),
//         ButtonSegment<Sizes>(value: Sizes.medium, label: Text('M')),
//         ButtonSegment<Sizes>(
//           value: Sizes.large,
//           label: Text('L'),
//         ),
//         ButtonSegment<Sizes>(value: Sizes.extraLarge, label: Text('XL')),
//       ],
//       selected: selection,
//       onSelectionChanged: (newSelection) {
//         setState(() {
//           selection = newSelection;
//         });
//       },
//       multiSelectionEnabled: true,
//     );
//   }
// }

// class SnackBarSection extends StatelessWidget {
//   const SnackBarSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Snackbar',
//       child: TextButton(
//         onPressed: () {
//           final snackBar = SnackBar(
//             behavior: SnackBarBehavior.floating,
//             width: 400.0,
//             content: const Text('This is a snackbar'),
//             action: SnackBarAction(
//               label: 'Close',
//               onPressed: () {},
//             ),
//           );

//           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         },
//         child: const Text(
//           'Show snackbar',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class BottomAppBars extends StatelessWidget {
//   const BottomAppBars({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Bottom app bar',
//       child: Column(
//         children: [
//           SizedBox(
//             height: 80,
//             child: Scaffold(
//               floatingActionButton: FloatingActionButton(
//                 onPressed: () {},
//                 elevation: 0.0,
//                 child: const Icon(Icons.add),
//               ),
//               floatingActionButtonLocation:
//                   FloatingActionButtonLocation.endContained,
//               bottomNavigationBar: BottomAppBar(
//                 child: Row(
//                   children: <Widget>[
//                     const IconButtonAnchorExample(),
//                     IconButton(
//                       tooltip: 'Search',
//                       icon: const Icon(Icons.search),
//                       onPressed: () {},
//                     ),
//                     IconButton(
//                       tooltip: 'Favorite',
//                       icon: const Icon(Icons.favorite),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class IconButtonAnchorExample extends StatelessWidget {
//   const IconButtonAnchorExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MenuAnchor(
//       builder: (context, controller, child) {
//         return IconButton(
//           onPressed: () {
//             if (controller.isOpen) {
//               controller.close();
//             } else {
//               controller.open();
//             }
//           },
//           icon: const Icon(Icons.more_vert),
//         );
//       },
//       menuChildren: [
//         MenuItemButton(
//           child: const Text('Menu 1'),
//           onPressed: () {},
//         ),
//         MenuItemButton(
//           child: const Text('Menu 2'),
//           onPressed: () {},
//         ),
//         SubmenuButton(
//           menuChildren: <Widget>[
//             MenuItemButton(
//               onPressed: () {},
//               child: const Text('Menu 3.1'),
//             ),
//             MenuItemButton(
//               onPressed: () {},
//               child: const Text('Menu 3.2'),
//             ),
//             MenuItemButton(
//               onPressed: () {},
//               child: const Text('Menu 3.3'),
//             ),
//           ],
//           child: const Text('Menu 3'),
//         ),
//       ],
//     );
//   }
// }

// class ButtonAnchorExample extends StatelessWidget {
//   const ButtonAnchorExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MenuAnchor(
//       builder: (context, controller, child) {
//         return FilledButton.tonal(
//           onPressed: () {
//             if (controller.isOpen) {
//               controller.close();
//             } else {
//               controller.open();
//             }
//           },
//           child: const Text('Show menu'),
//         );
//       },
//       menuChildren: [
//         MenuItemButton(
//           leadingIcon: const Icon(Icons.people_alt_outlined),
//           child: const Text('Item 1'),
//           onPressed: () {},
//         ),
//         MenuItemButton(
//           leadingIcon: const Icon(Icons.remove_red_eye_outlined),
//           child: const Text('Item 2'),
//           onPressed: () {},
//         ),
//         MenuItemButton(
//           leadingIcon: const Icon(Icons.refresh),
//           onPressed: () {},
//           child: const Text('Item 3'),
//         ),
//       ],
//     );
//   }
// }

// class Dividers extends StatelessWidget {
//   const Dividers({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ComponentDecoration(
//       label: 'Dividers',
//       child: Column(
//         children: <Widget>[
//           Divider(key: Key('divider')),
//         ],
//       ),
//     );
//   }
// }

// class Checkboxes extends StatefulWidget {
//   const Checkboxes({super.key});

//   @override
//   State<Checkboxes> createState() => _CheckboxesState();
// }

// class _CheckboxesState extends State<Checkboxes> {
//   bool? isChecked0 = true;
//   bool? isChecked1;
//   bool? isChecked2 = false;

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Checkboxes',
//       child: Column(
//         children: <Widget>[
//           CheckboxListTile(
//             tristate: true,
//             value: isChecked0,
//             title: const Text('Option 1'),
//             onChanged: (value) {
//               setState(() {
//                 isChecked0 = value;
//               });
//             },
//           ),
//           CheckboxListTile(
//             tristate: true,
//             value: isChecked1,
//             title: const Text('Option 2'),
//             onChanged: (value) {
//               setState(() {
//                 isChecked1 = value;
//               });
//             },
//           ),
//           CheckboxListTile(
//             tristate: true,
//             value: isChecked2,
//             title: const Text('Option 3'),
//             // TODO: showcase error state https://github.com/flutter/flutter/issues/118616
//             onChanged: (value) {
//               setState(() {
//                 isChecked2 = value;
//               });
//             },
//           ),
//           const CheckboxListTile(
//             tristate: true,
//             title: Text('Option 4'),
//             value: true,
//             onChanged: null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// enum Value { first, second }

// class Radios extends StatefulWidget {
//   const Radios({super.key});

//   @override
//   State<Radios> createState() => _RadiosState();
// }

// enum Options { option1, option2, option3 }

// class _RadiosState extends State<Radios> {
//   Options? _selectedOption = Options.option1;

//   @override
//   Widget build(BuildContext context) {
//     return ComponentDecoration(
//       label: 'Radio buttons',
//       child: Column(
//         children: <Widget>[
//           RadioListTile<Options>(
//             title: const Text('Option 1'),
//             value: Options.option1,
//             groupValue: _selectedOption,
//             onChanged: (value) {
//               setState(() {
//                 _selectedOption = value;
//               });
//             },
//           ),
//           RadioListTile<Options>(
//             title: const Text('Option 2'),
//             value: Options.option2,
//             groupValue: _selectedOption,
//             onChanged: (value) {
//               setState(() {
//                 _selectedOption = value;
//               });
//             },
//           ),
//           RadioListTile<Options>(
//             title: const Text('Option 3'),
//             value: Options.option3,
//             groupValue: _selectedOption,
//             onChanged: null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProgressIndicators extends StatefulWidget {
//   const ProgressIndicators({super.key});

//   @override
//   State<ProgressIndicators> createState() => _ProgressIndicatorsState();
// }

// class _ProgressIndicatorsState extends State<ProgressIndicators> {
//   bool playProgressIndicator = false;

//   @override
//   Widget build(BuildContext context) {
//     final double? progressValue = playProgressIndicator ? null : 0.7;

//     return ComponentDecoration(
//       label: 'Progress indicators',
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: [
//               IconButton(
//                 isSelected: playProgressIndicator,
//                 selectedIcon: const Icon(Icons.pause),
//                 icon: const Icon(Icons.play_arrow),
//                 onPressed: () {
//                   setState(() {
//                     playProgressIndicator = !playProgressIndicator;
//                   });
//                 },
//               ),
//               Expanded(
//                 child: Row(
//                   children: <Widget>[
//                     rowDivider,
//                     CircularProgressIndicator(
//                       value: progressValue,
//                     ),
//                     rowDivider,
//                     Expanded(
//                       child: LinearProgressIndicator(
//                         value: progressValue,
//                       ),
//                     ),
//                     rowDivider,
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
