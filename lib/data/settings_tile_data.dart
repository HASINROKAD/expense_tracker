import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/add_expense_screen.dart';
import '../screens/add_income_screen.dart';

class SettingTile {
  final String title;
  final Widget route;
  final Widget icon;

  SettingTile({
    required this.title,
    required this.route,
    required this.icon,
  });
}

final List<SettingTile> settingTiles = [
  SettingTile(
    title: 'Preference',
    route: AddIncomeScreen(),
    icon: FaIcon(FontAwesomeIcons.sliders),
  ),
  SettingTile(
    title: 'Notification',
    route: AddExpenseScreen(),
    icon: FaIcon(FontAwesomeIcons.bell),
  ),
  SettingTile(
    title: 'Privacy & Security',
    route: AddExpenseScreen(),
    icon: FaIcon(FontAwesomeIcons.lock),
  ),
];

final List<SettingTile> settingTiles2 = [
  SettingTile(
    title: 'Accounts',
    route: AddIncomeScreen(),
    icon: FaIcon(FontAwesomeIcons.user),
  ),
  SettingTile(
    title: 'Backup & Sync',
    route: AddIncomeScreen(),
    icon: FaIcon(FontAwesomeIcons.cloudArrowUp),
  ),
  SettingTile(
    title: 'About Us & Legal',
    route: AddIncomeScreen(),
    icon: FaIcon(FontAwesomeIcons.circleInfo),
  ),
];


