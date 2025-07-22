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
    const HomeScreen(),
    const StatesScreen(),
    const AddScreen(),
    const CalenderScreen(),
    const SettingsScreen(),
  ];

  // List of titles corresponding to each screen
  final List<String> _appBarTitles = [
    'Home',
    'Stats',
    'History',
    'Calender',
    'Settings',
  ];

  // Helper method to get app bar background color based on theme
  Color _getAppBarBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? TColors.primaryDark
        : TColors.primary;
  }

  // Helper method to get navigation bar color based on theme
  Color _getNavigationBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? TColors.primaryDark
        : TColors.primary;
  }

  // Helper method to get navigation background color based on theme
  Color _getNavigationBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? TColors.backgroundDark
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getAppBarBackgroundColor(context),
        foregroundColor: TColors.textWhite,
        elevation: Theme.of(context).brightness == Brightness.dark ? 8 : 4,
        shadowColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.grey.withValues(alpha: 0.3),
        title: Text(
          _appBarTitles[_selectedIndex],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
        ), // Dynamic title based on selected index
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 250),
        backgroundColor: _getNavigationBackgroundColor(context),
        color: _getNavigationBarColor(context),
        buttonBackgroundColor: _getNavigationBarColor(context),
        height: 60,
        items: [
          Icon(FontAwesomeIcons.clipboardList,
              color: TColors.textWhite, size: 22),
          Icon(FontAwesomeIcons.chartSimple,
              color: TColors.textWhite, size: 22),
          Icon(FontAwesomeIcons.plus, color: TColors.textWhite, size: 24),
          Icon(FontAwesomeIcons.calendar, color: TColors.textWhite, size: 22),
          Icon(FontAwesomeIcons.gear, color: TColors.textWhite, size: 22),
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
