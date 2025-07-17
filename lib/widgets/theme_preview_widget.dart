import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/theme_utils.dart';
import '../theme/theme_manager.dart';

/// Widget that shows a preview of different themes
class ThemePreviewWidget extends StatelessWidget {
  final String currentTheme;
  final Function(String) onThemeSelected;

  const ThemePreviewWidget({
    super.key,
    required this.currentTheme,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ThemeUtils.getContainerDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeUtils.getPrimaryColor(context)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.palette,
                    size: 20,
                    color: ThemeUtils.getPrimaryColor(context),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: ThemeManager.availableThemes.map((theme) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onThemeSelected(theme.name),
                    child: _buildThemeOption(
                        context, theme, currentTheme == theme.name),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context, ThemeOption theme, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected ? TColors.primary : Colors.grey.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Theme preview
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              color: _getPreviewBackgroundColor(context, theme.key),
            ),
            child: Stack(
              children: [
                // Mock app bar
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getPreviewPrimaryColor(context, theme.key),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                  ),
                ),
                // Mock content
                Positioned(
                  top: 30,
                  left: 8,
                  right: 8,
                  child: Column(
                    children: [
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getPreviewCardColor(context, theme.key),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _getPreviewTextColor(context, theme.key),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 8,
                        width: 60,
                        decoration: BoxDecoration(
                          color: _getPreviewTextColor(context, theme.key),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Theme info
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  theme.icon,
                  size: 16,
                  color: isSelected ? TColors.primary : Colors.grey[600],
                ),
                const SizedBox(height: 4),
                Text(
                  theme.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? TColors.primary : null,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPreviewBackgroundColor(BuildContext context, String themeKey) {
    switch (themeKey) {
      case 'light':
        return Colors.white;
      case 'dark':
        return const Color(0xFF121212);
      case 'system':
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? const Color(0xFF121212)
            : Colors.white;
      default:
        return Colors.white;
    }
  }

  Color _getPreviewPrimaryColor(BuildContext context, String themeKey) {
    switch (themeKey) {
      case 'light':
        return TColors.primary;
      case 'dark':
        return TColors.primaryDark;
      case 'system':
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? TColors.primaryDark
            : TColors.primary;
      default:
        return TColors.primary;
    }
  }

  Color _getPreviewCardColor(BuildContext context, String themeKey) {
    switch (themeKey) {
      case 'light':
        return Colors.grey[100]!;
      case 'dark':
        return const Color(0xFF1E1E1E);
      case 'system':
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.grey[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getPreviewTextColor(BuildContext context, String themeKey) {
    switch (themeKey) {
      case 'light':
        return Colors.grey[300]!;
      case 'dark':
        return Colors.grey[600]!;
      case 'system':
        return MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.grey[600]!
            : Colors.grey[300]!;
      default:
        return Colors.grey[300]!;
    }
  }
}
