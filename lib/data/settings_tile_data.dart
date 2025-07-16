import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../sub_settings/preference_screen.dart';
import '../sub_settings/notification_screen.dart';
import '../sub_settings/privacy_security_screen.dart';
import '../sub_settings/account_screen.dart';
import '../sub_settings/backup_sync_screen.dart';
import '../sub_settings/about_legal_screen.dart';

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
    route: PreferenceScreen(),
    icon: FaIcon(FontAwesomeIcons.sliders),
  ),
  SettingTile(
    title: 'Notification',
    route: NotificationScreen(),
    icon: FaIcon(FontAwesomeIcons.bell),
  ),
  SettingTile(
    title: 'Privacy & Security',
    route: PrivacySecurityScreen(),
    icon: FaIcon(FontAwesomeIcons.lock),
  ),
];

final List<SettingTile> settingTiles2 = [
  SettingTile(
    title: 'Accounts',
    route: AccountScreen(),
    icon: FaIcon(FontAwesomeIcons.user),
  ),
  SettingTile(
    title: 'Backup & Sync',
    route: BackupSyncScreen(),
    icon: FaIcon(FontAwesomeIcons.cloudArrowUp),
  ),
  SettingTile(
    title: 'About Us & Legal',
    route: AboutLegalScreen(),
    icon: FaIcon(FontAwesomeIcons.circleInfo),
  ),
];
