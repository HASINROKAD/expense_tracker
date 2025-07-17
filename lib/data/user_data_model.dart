import 'package:flutter/foundation.dart';

/// User data model that matches the tbl_user_data table structure
class UserData {
  final String id;
  final DateTime createdAt;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? phoneNumber;
  final String userUuid;

  UserData({
    required this.id,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.userName,
    this.phoneNumber,
    required this.userUuid,
  });

  /// Create UserData from Supabase record
  factory UserData.fromSupabaseRecord(Map<String, dynamic> record) {
    return UserData(
      id: record['id']?.toString() ?? '',
      createdAt: DateTime.parse(
        record['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      firstName: record['first_name']?.toString(),
      lastName: record['last_name']?.toString(),
      userName: record['user_name']?.toString(),
      phoneNumber: record['phone_number']?.toString(),
      userUuid: record['user_uuid']?.toString() ?? '',
    );
  }

  /// Convert UserData to Supabase record format
  Map<String, dynamic> toSupabaseRecord() {
    return {
      'id': id.isEmpty ? null : id,
      'created_at': createdAt.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'phone_number': phoneNumber,
      'user_uuid': userUuid,
    };
  }

  /// Convert UserData to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'phone_number': phoneNumber,
      'user_uuid': userUuid,
    };
  }

  /// Create UserData from JSON (local storage)
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      createdAt: DateTime.parse(
        json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      userName: json['user_name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      userUuid: json['user_uuid']?.toString() ?? '',
    );
  }

  /// Get full name (first + last)
  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    if (first.isEmpty && last.isEmpty) {
      return userName ?? 'User';
    }
    return '$first $last'.trim();
  }

  /// Get display name (prioritizes fullName over userName)
  String get displayName {
    final full = fullName;
    if (full.isNotEmpty && full != 'User') {
      return full;
    }
    if (userName != null && userName!.isNotEmpty) {
      return userName!;
    }
    return 'User';
  }

  /// Get formatted phone number (12345 12345 format)
  String get formattedPhoneNumber {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return 'Not provided';
    }
    // Remove any non-digit characters
    final phone = phoneNumber!.replaceAll(RegExp(r'[^\d]'), '');

    // Format as 12345 12345 (5+5 digits with space)
    if (phone.length == 10) {
      return '${phone.substring(0, 5)} ${phone.substring(5)}';
    }
    // If not exactly 10 digits, return as is
    return phone;
  }

  /// Check if user data is complete
  bool get isComplete {
    return firstName != null &&
        firstName!.isNotEmpty &&
        lastName != null &&
        lastName!.isNotEmpty &&
        userName != null &&
        userName!.isNotEmpty;
  }

  /// Get completion percentage (0.0 to 1.0)
  double get completionPercentage {
    int filledFields = 0;
    const int totalFields = 4; // firstName, lastName, userName, phoneNumber

    if (firstName != null && firstName!.isNotEmpty) filledFields++;
    if (lastName != null && lastName!.isNotEmpty) filledFields++;
    if (userName != null && userName!.isNotEmpty) filledFields++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) filledFields++;

    return filledFields / totalFields;
  }

  /// Create a copy with updated fields
  UserData copyWith({
    String? id,
    DateTime? createdAt,
    String? firstName,
    String? lastName,
    String? userName,
    String? phoneNumber,
    String? userUuid,
  }) {
    return UserData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userUuid: userUuid ?? this.userUuid,
    );
  }

  /// Create empty UserData for new user
  factory UserData.empty(String userUuid) {
    return UserData(
      id: '',
      createdAt: DateTime.now(),
      userUuid: userUuid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.id == id &&
        other.userUuid == userUuid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.userName == userName &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userUuid,
      firstName,
      lastName,
      userName,
      phoneNumber,
    );
  }

  @override
  String toString() {
    return 'UserData{id: $id, fullName: $fullName, userName: $userName, userUuid: $userUuid}';
  }
}

/// User preferences and settings
class UserPreferences {
  final String userUuid;
  final String theme; // 'light', 'dark', 'system'
  final String language; // 'en', 'es', 'fr', etc.
  final String currency; // 'USD', 'EUR', 'INR', etc.
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool autoBackup;
  final String defaultCountry;

  UserPreferences({
    required this.userUuid,
    this.theme = 'system',
    this.language = 'en',
    this.currency = 'INR',
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.autoBackup = true,
    this.defaultCountry = 'India',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      userUuid: json['user_uuid']?.toString() ?? '',
      theme: json['theme']?.toString() ?? 'system',
      language: json['language']?.toString() ?? 'en',
      currency: json['currency']?.toString() ?? 'INR',
      notificationsEnabled: json['notifications_enabled'] ?? true,
      biometricEnabled: json['biometric_enabled'] ?? false,
      autoBackup: json['auto_backup'] ?? true,
      defaultCountry: json['default_country']?.toString() ?? 'India',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uuid': userUuid,
      'theme': theme,
      'language': language,
      'currency': currency,
      'notifications_enabled': notificationsEnabled,
      'biometric_enabled': biometricEnabled,
      'auto_backup': autoBackup,
      'default_country': defaultCountry,
    };
  }

  UserPreferences copyWith({
    String? userUuid,
    String? theme,
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    bool? autoBackup,
    String? defaultCountry,
  }) {
    return UserPreferences(
      userUuid: userUuid ?? this.userUuid,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoBackup: autoBackup ?? this.autoBackup,
      defaultCountry: defaultCountry ?? this.defaultCountry,
    );
  }

  factory UserPreferences.defaultForUser(String userUuid) {
    return UserPreferences(
      userUuid: userUuid,
      defaultCountry: 'India', // Based on user's memory preference
    );
  }
}
