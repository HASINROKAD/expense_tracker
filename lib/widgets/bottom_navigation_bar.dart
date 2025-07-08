import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/add_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/calendar_screen.dart';
import 'package:expense_tracker/screens/settings_screen.dart';
import 'package:expense_tracker/screens/state_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    HomeScreen(),
    StatesScreen(),
    AddScreen(),
    CalenderScreen(),
    SettingsScreen(),
  ];

  // List of titles corresponding to each screen
  final List<String> _appBarTitles = [
    'Home',
    'Stats',
    'History',
    'Calender',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        title: Text(
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: TColors.textWhite),
          _appBarTitles[_selectedIndex],
        ), // Dynamic title based on selected index
        actions: [
          if (_appBarTitles[_selectedIndex] != 'Settings')
            IconButton(
              color: TColors.textWhite,
              iconSize: 20,
              icon: Icon(FontAwesomeIcons.magnifyingGlass),
              onPressed: () {
                // Add search functionality here
              },
            ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 250),
        backgroundColor: Colors.white,
        color: TColors.primary,
        items: [
          Icon(FontAwesomeIcons.clipboardList, color: TColors.textWhite),
          Icon(FontAwesomeIcons.chartSimple, color: TColors.textWhite),
          Icon(FontAwesomeIcons.plus, color: TColors.textWhite),
          Icon(FontAwesomeIcons.calendar, color: TColors.textWhite),
          Icon(FontAwesomeIcons.gear, color: TColors.textWhite),
        ],
        onTap: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }
}
