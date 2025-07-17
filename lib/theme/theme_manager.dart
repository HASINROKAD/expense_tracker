import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import 'theme.dart';

/// Theme manager that handles theme switching based on user preferences
class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  final LocalDataManager _dataManager = LocalDataManager();

  // Current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Current theme preference from user settings
  String _themePreference = 'system';

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Get current theme preference
  String get themePreference => _themePreference;

  /// Get light theme data
  ThemeData get lightTheme => AppTheme.lightTheme;

  /// Get dark theme data
  ThemeData get darkTheme => AppTheme.darkTheme;

  /// Initialize theme manager and load user preferences
  Future<void> initialize() async {
    try {
      await _dataManager.initialize();
      _loadThemeFromPreferences();

      // Listen to data manager changes
      _dataManager.addListener(_onDataManagerChanged);
    } catch (error) {
      // If loading fails, use system default
      _themeMode = ThemeMode.system;
      _themePreference = 'system';
    }
  }

  /// Load theme from user preferences
  void _loadThemeFromPreferences() {
    final preferences = _dataManager.userPreferences;
    if (preferences != null) {
      _themePreference = preferences.theme;
      _updateThemeMode(_themePreference);
    }
  }

  /// Handle data manager changes
  void _onDataManagerChanged() {
    final preferences = _dataManager.userPreferences;
    if (preferences != null && preferences.theme != _themePreference) {
      _themePreference = preferences.theme;
      _updateThemeMode(_themePreference);
    }
  }

  /// Update theme mode based on preference string
  void _updateThemeMode(String preference) {
    final newThemeMode = _getThemeModeFromString(preference);
    if (newThemeMode != _themeMode) {
      _themeMode = newThemeMode;
      notifyListeners();
    }
  }

  /// Convert string preference to ThemeMode
  ThemeMode _getThemeModeFromString(String preference) {
    switch (preference.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Set theme preference and save to user preferences
  Future<void> setTheme(String themePreference) async {
    if (_themePreference == themePreference) return;

    try {
      final currentPreferences = _dataManager.userPreferences;
      if (currentPreferences != null) {
        final updatedPreferences = currentPreferences.copyWith(
          theme: themePreference,
        );

        await _dataManager.updateUserPreferences(updatedPreferences);

        // Update local state
        _themePreference = themePreference;
        _updateThemeMode(themePreference);
      }
    } catch (error) {
      // If saving fails, still update local state for immediate UI feedback
      _themePreference = themePreference;
      _updateThemeMode(themePreference);
      rethrow;
    }
  }

  /// Get current effective theme (light/dark) considering system setting
  Brightness getCurrentBrightness(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness;
    }
  }

  /// Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  /// Check if current theme is light
  bool isLightMode(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.light;
  }

  /// Get theme data based on brightness
  ThemeData getThemeData(Brightness brightness) {
    return brightness == Brightness.dark ? darkTheme : lightTheme;
  }

  /// Dispose resources
  @override
  void dispose() {
    _dataManager.removeListener(_onDataManagerChanged);
    super.dispose();
  }

  /// Get available theme options for UI
  static List<ThemeOption> get availableThemes => [
        ThemeOption(
          key: 'light',
          name: 'Light',
          description: 'Light theme with bright colors',
          icon: Icons.light_mode,
        ),
        ThemeOption(
          key: 'dark',
          name: 'Dark',
          description: 'Dark theme with muted colors',
          icon: Icons.dark_mode,
        ),
        ThemeOption(
          key: 'system',
          name: 'System',
          description: 'Follow system theme setting',
          icon: Icons.settings_brightness,
        ),
      ];
}

/// Theme option data class
class ThemeOption {
  final String key;
  final String name;
  final String description;
  final IconData icon;

  const ThemeOption({
    required this.key,
    required this.name,
    required this.description,
    required this.icon,
  });
}
