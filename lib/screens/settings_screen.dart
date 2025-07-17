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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Row(
                    children: [
                      Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
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
                            _dataManager.userData?.displayName ?? 'User Name',
                            style: Theme.of(context).textTheme.headlineMedium,
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
                                color: Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Profile ${(_dataManager.userData!.completionPercentage * 100).toInt()}% complete',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.orange,
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
              const SizedBox(height: 10),
              const Divider(color: TColors.containerPrimary),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  settingTiles.length,
                  (index) => SettingTileWidget(
                    settingTile: settingTiles[index],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: TColors.containerPrimary),
              const SizedBox(height: 10),
              Column(
                children: List.generate(
                  settingTiles2.length,
                  (index) => SettingTileWidget(
                    settingTile: settingTiles2[index],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: TColors.containerPrimary),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final client = SupabaseAuth.client();
                  await client.auth.signOut();

                  // Clear local data cache
                  _dataManager.clearCache();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully signed out')),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: TColors.containerPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: FaIcon(FontAwesomeIcons.rightFromBracket),
                        ),
                      ), // Use the icon
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 35,
                      child: Text(
                        'Log Out',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: TColors.containerPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent_rounded, size: 35),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Feel free to ask, We ready to help',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
