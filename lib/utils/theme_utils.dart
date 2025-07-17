import 'package:flutter/material.dart';
import 'constants/colors.dart';

/// Utility class for theme-aware styling
class ThemeUtils {
  ThemeUtils._();

  /// Get container color based on theme
  static Color getContainerColor(BuildContext context, {bool elevated = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return elevated ? TColors.containerSecondaryDark : TColors.containerPrimaryDark;
    } else {
      return elevated ? TColors.containerSecondary : TColors.containerPrimary;
    }
  }

  /// Get surface color based on theme
  static Color getSurfaceColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? TColors.surfaceDark : Colors.white;
  }

  /// Get text color based on theme and importance
  static Color getTextColor(BuildContext context, {TextImportance importance = TextImportance.primary}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      switch (importance) {
        case TextImportance.primary:
          return TColors.textPrimaryDark;
        case TextImportance.secondary:
          return TColors.textSecondaryDark;
        case TextImportance.tertiary:
          return TColors.textTertiaryDark;
      }
    } else {
      switch (importance) {
        case TextImportance.primary:
          return TColors.textPrimary;
        case TextImportance.secondary:
          return TColors.textSecondary;
        case TextImportance.tertiary:
          return Colors.grey[600]!;
      }
    }
  }

  /// Get border color based on theme
  static Color getBorderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? TColors.borderDark : TColors.containerPrimary;
  }

  /// Get divider color based on theme
  static Color getDividerColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? TColors.dividerDark : Colors.grey[300]!;
  }

  /// Get shadow color based on theme
  static Color getShadowColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.black54 : Colors.grey.withValues(alpha: 0.3);
  }

  /// Create theme-aware box decoration for containers
  static BoxDecoration getContainerDecoration(
    BuildContext context, {
    bool elevated = false,
    double borderRadius = 12,
    bool withBorder = true,
    bool withShadow = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BoxDecoration(
      color: getContainerColor(context, elevated: elevated),
      borderRadius: BorderRadius.circular(borderRadius),
      border: withBorder 
          ? Border.all(
              color: getBorderColor(context).withValues(alpha: isDark ? 0.3 : 0.5),
            )
          : null,
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: getShadowColor(context),
                blurRadius: isDark ? 8 : 4,
                offset: Offset(0, isDark ? 4 : 2),
              ),
            ]
          : null,
    );
  }

  /// Create theme-aware card decoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BoxDecoration(
      color: getSurfaceColor(context),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: getShadowColor(context),
          blurRadius: isDark ? 12 : 6,
          offset: Offset(0, isDark ? 6 : 3),
        ),
      ],
    );
  }

  /// Get primary color based on theme
  static Color getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? TColors.primaryDark : TColors.primary;
  }

  /// Get secondary color based on theme
  static Color getSecondaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? TColors.secondaryDark : TColors.secondary;
  }

  /// Create theme-aware elevated button style
  static ButtonStyle getElevatedButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: getPrimaryColor(context),
      foregroundColor: TColors.textWhite,
      elevation: Theme.of(context).brightness == Brightness.dark ? 8 : 2,
      shadowColor: getShadowColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  /// Create theme-aware text button style
  static ButtonStyle getTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: getPrimaryColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Create theme-aware outlined button style
  static ButtonStyle getOutlinedButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: getPrimaryColor(context),
      side: BorderSide(color: getPrimaryColor(context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }
}

/// Enum for text importance levels
enum TextImportance {
  primary,
  secondary,
  tertiary,
}
