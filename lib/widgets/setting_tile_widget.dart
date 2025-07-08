import 'package:expense_tracker/data/settings_tile_data.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class SettingTileWidget extends StatelessWidget {
  final SettingTile settingTile;

  const SettingTileWidget({super.key, required this.settingTile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => settingTile.route,
          ),
        );
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
                child: settingTile.icon,
              ),
            ), // Use the icon
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 35,
            child: Text(
              settingTile.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right_outlined),
        ],
      ),
    );
  }
}
