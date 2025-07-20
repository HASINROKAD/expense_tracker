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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.primaryDark.withValues(alpha: 0.2)
                    : TColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? TColors.primaryDark.withValues(alpha: 0.3)
                      : TColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: settingTile.icon,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                settingTile.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.textPrimaryDark
                          : TColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right_outlined,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.textSecondaryDark
                  : TColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
