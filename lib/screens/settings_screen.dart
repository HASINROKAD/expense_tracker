import 'package:expense_tracker/data/settings_tile_data.dart';
import 'package:expense_tracker/screens/login/login_screen.dart';
import 'package:expense_tracker/widgets/setting_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../data/supabase_auth.dart';
import '../data/local_data_manager.dart';
import '../utils/constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalDataManager _dataManager = LocalDataManager();

  @override
  void initState() {
    super.initState();
    _dataManager.addListener(_onDataChanged);
    _initializeData();
  }

  @override
  void dispose() {
    _dataManager.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeData() async {
    await _dataManager.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? TColors.backgroundDark
          : Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation:
                    Theme.of(context).brightness == Brightness.dark ? 8 : 4,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.surfaceDark
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black54
                                      : Colors.grey.withValues(alpha: 0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(
                                  'assets/images/expense_tracker_logo.jpeg'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _dataManager.userData?.displayName ??
                                    'User Name',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                _dataManager.userData?.formattedPhoneNumber ??
                                    'Mobile number',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if (_dataManager.userData != null &&
                                  !_dataManager.userData!.isComplete)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.orange.withValues(alpha: 0.3)
                                        : Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Profile ${(_dataManager.userData!.completionPercentage * 100).toInt()}% complete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.orange[300]
                                              : Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Edit profile button removed
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation:
                    Theme.of(context).brightness == Brightness.dark ? 6 : 3,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.surfaceDark
                    : Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    children: List.generate(
                      settingTiles.length,
                      (index) => Column(
                        children: [
                          SettingTileWidget(
                            settingTile: settingTiles[index],
                          ),
                          if (index < settingTiles.length - 1)
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.dividerDark.withValues(alpha: 0.3)
                                  : TColors.containerPrimary
                                      .withValues(alpha: 0.3),
                              height: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation:
                    Theme.of(context).brightness == Brightness.dark ? 6 : 3,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.surfaceDark
                    : Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    children: List.generate(
                      settingTiles2.length,
                      (index) => Column(
                        children: [
                          SettingTileWidget(
                            settingTile: settingTiles2[index],
                          ),
                          if (index < settingTiles2.length - 1)
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.dividerDark.withValues(alpha: 0.3)
                                  : TColors.containerPrimary
                                      .withValues(alpha: 0.3),
                              height: 16,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation:
                    Theme.of(context).brightness == Brightness.dark ? 6 : 3,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.surfaceDark
                    : Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: GestureDetector(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final client = SupabaseAuth.client();

                      await client.auth.signOut();

                      // Clear local data cache
                      _dataManager.clearCache();

                      if (mounted) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Successfully signed out'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        navigator.pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.red[600],
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Log Out',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.red[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation:
                    Theme.of(context).brightness == Brightness.dark ? 6 : 3,
                shadowColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Colors.grey.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [
                              TColors.primaryDark.withValues(alpha: 0.2),
                              TColors.primaryDark.withValues(alpha: 0.1),
                            ]
                          : [
                              TColors.primary.withValues(alpha: 0.1),
                              TColors.primary.withValues(alpha: 0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.primaryDark.withValues(alpha: 0.2)
                              : TColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 28,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? TColors.primaryDark
                              : TColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need Help?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? TColors.primaryDark
                                        : TColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Feel free to ask, We\'re ready to help',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? TColors.textSecondaryDark
                                        : Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
