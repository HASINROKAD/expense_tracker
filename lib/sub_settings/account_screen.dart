import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';
import '../data/local_data_manager.dart';
import '../data/user_data_model.dart';
import '../data/supabase_auth.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? TColors.primaryDark
            : TColors.primary,
        foregroundColor: TColors.textWhite,
        elevation: Theme.of(context).brightness == Brightness.dark ? 8 : 4,
        shadowColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black54
            : Colors.grey.withValues(alpha: 0.3),
        // Edit profile action removed
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileCard(),
            const SizedBox(height: 24),

            // Account Status
            _buildSectionHeader('Account Status'),
            _buildStatusTile(
              'Email Verification',
              'Verified', // Assuming verified since user is logged in
              FontAwesomeIcons.circleCheck,
              TColors.primary,
              null,
            ),
            _buildStatusTile(
              'Phone Verification',
              (_dataManager.userData?.phoneNumber?.isNotEmpty ?? false)
                  ? 'Verified'
                  : 'Not Verified',
              (_dataManager.userData?.phoneNumber?.isNotEmpty ?? false)
                  ? FontAwesomeIcons.circleCheck
                  : FontAwesomeIcons.circleXmark,
              (_dataManager.userData?.phoneNumber?.isNotEmpty ?? false)
                  ? TColors.primary
                  : TColors.errorPrimary,
              (_dataManager.userData?.phoneNumber?.isNotEmpty ?? false)
                  ? null
                  : _verifyPhone,
            ),
            _buildStatusTile(
              'Two-Factor Authentication',
              'Disabled', // Default to disabled
              FontAwesomeIcons.shieldHalved,
              TColors.errorPrimary,
              _toggle2FA,
            ),
            const SizedBox(height: 24),

            // Account Statistics
            _buildSectionHeader('Account Statistics'),
            _buildStatsCard(),
            const SizedBox(height: 24),

            // Account Actions
            _buildSectionHeader('Account Actions'),
            _buildActionTile(
              'Change Password',
              'Update your account password',
              FontAwesomeIcons.key,
              TColors.primary,
              _changePassword,
            ),
            _buildActionTile(
              'Download Data',
              'Export all your account data',
              FontAwesomeIcons.download,
              TColors.secondary,
              _downloadData,
            ),

            _buildActionTile(
              'Delete Account',
              'Permanently delete your account',
              FontAwesomeIcons.trash,
              TColors.errorPrimary,
              _deleteAccount,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 53, 111, 111)
                      : TColors.primary,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        TColors.primaryDark,
                        TColors.primaryDark.withValues(alpha: 0.5),
                      ]
                    : [
                        TColors.primary,
                        TColors.primary.withValues(alpha: 0.5),
                      ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userData = _dataManager.userData;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  TColors.primaryDark,
                  TColors.primaryDark.withValues(alpha: 0.9),
                  TColors.secondaryDark,
                ]
              : [
                  TColors.primary,
                  TColors.primary.withValues(alpha: 0.9),
                  TColors.secondary,
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? TColors.primaryDark : TColors.primary)
                .withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: (isDark ? TColors.secondaryDark : TColors.secondary)
                .withValues(alpha: 0.1),
            blurRadius: 48,
            offset: const Offset(0, 24),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background pattern overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Header section with avatar and basic info
                  Row(
                    children: [
                      // Modern avatar design
                      _buildModernAvatar(),
                      const SizedBox(width: 24),
                      // User info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              userData?.displayName ?? 'User Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: TColors.textWhite,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                    height: 1.2,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Contact information section
                  _buildContactInfo(),
                  const SizedBox(height: 24),
                  // Edit Profile button
                  _buildEditProfileButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern avatar with enhanced design
  Widget _buildModernAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            TColors.textWhite.withValues(alpha: 0.3),
            TColors.textWhite.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TColors.textWhite.withValues(alpha: 0.2),
          border: Border.all(
            color: TColors.textWhite.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: TColors.textWhite.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main icon
            FaIcon(
              FontAwesomeIcons.user,
              size: 36,
              color: TColors.textWhite,
            ),
            // Highlight effect
            Positioned(
              top: 12,
              left: 20,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: TColors.textWhite.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: TColors.textWhite.withValues(alpha: 0.6),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contact information section
  Widget _buildContactInfo() {
    final userData = _dataManager.userData;
    final client = SupabaseAuth.client();
    final email = client.auth.currentUser?.email ?? 'user@example.com';
    final phone = userData?.formattedPhoneNumber;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TColors.textWhite.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TColors.textWhite.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Email
          _buildContactItem(
            icon: FontAwesomeIcons.envelope,
            label: 'Email',
            value: email,
            onTap: () {
              // Could add email functionality here
            },
          ),
          if (phone != null && phone.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildContactItem(
              icon: FontAwesomeIcons.phone,
              label: 'Phone',
              value: phone,
              onTap: () {
                // Could add phone functionality here
              },
            ),
          ],
          const SizedBox(height: 16),
          _buildContactItem(
            icon: FontAwesomeIcons.calendar,
            label: 'Member Since',
            value: _formatMemberSince(userData?.createdAt),
            onTap: null,
          ),
        ],
      ),
    );
  }

  // Individual contact item
  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColors.textWhite.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FaIcon(
                icon,
                size: 16,
                color: TColors.textWhite.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TColors.textWhite.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textWhite.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: 14,
                color: TColors.textWhite.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }

  // Edit Profile button
  Widget _buildEditProfileButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TColors.textWhite.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TColors.textWhite.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _editProfile,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.pen,
                  size: 18,
                  color: TColors.textWhite.withValues(alpha: 0.9),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: TColors.textWhite.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Format member since date
  String _formatMemberSince(DateTime? createdAt) {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  Widget _buildStatusTile(
    String title,
    String status,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: Theme.of(context).brightness == Brightness.dark ? 6 : 3,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? TColors.surfaceDark
          : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 20,
                  color: (icon ==
                          FontAwesomeIcons.shieldHalved) // Two-factor auth icon
                      ? color // Keep original color
                      : (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : color),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.textPrimaryDark
                                    : TColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: (icon ==
                          FontAwesomeIcons.shieldHalved) // Two-factor auth icon
                      ? color // Keep original color
                      : (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : color),
                  size: 24,
                )
              else
                FaIcon(
                  FontAwesomeIcons.check,
                  color: (icon ==
                          FontAwesomeIcons.shieldHalved) // Two-factor auth icon
                      ? color // Keep original color
                      : (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : color),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: Theme.of(context).brightness == Brightness.dark ? 6 : 3,
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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Transactions',
                _dataManager
                    .getUserStatistics()['totalTransactions']
                    .toString(),
                FontAwesomeIcons.receipt,
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.borderDark
                  : Colors.grey[300],
            ),
            Expanded(
              child: _buildStatItem(
                'Categories',
                _dataManager
                    .getUserStatistics()['categoriesCreated']
                    .toString(),
                FontAwesomeIcons.tags,
              ),
            ),
            Container(
              width: 1,
              height: 50,
              color: Theme.of(context).brightness == Brightness.dark
                  ? TColors.borderDark
                  : Colors.grey[300],
            ),
            Expanded(
              child: _buildStatItem(
                'Days Active',
                _dataManager.getUserStatistics()['daysActive'].toString(),
                FontAwesomeIcons.calendar,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
          child: FaIcon(
            icon,
            size: 24,
            color: Theme.of(context).brightness == Brightness.dark
                ? TColors.textWhite
                : TColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.primaryDark
                    : TColors.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? TColors.textSecondaryDark
                    : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: Theme.of(context).brightness == Brightness.dark ? 6 : 3,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? TColors.surfaceDark
          : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 20,
                  color: (icon == FontAwesomeIcons.trash &&
                          color == TColors.errorPrimary) // Delete account icon
                      ? color // Keep original red color
                      : (Theme.of(context).brightness == Brightness.dark
                          ? TColors.textWhite
                          : color),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.textSecondaryDark
                                    : Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: (icon == FontAwesomeIcons.trash &&
                        color == TColors.errorPrimary) // Delete account icon
                    ? color // Keep original red color
                    : (Theme.of(context).brightness == Brightness.dark
                        ? TColors.textWhite
                        : color),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyPhone() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone verification code sent!')),
    );
  }

  void _toggle2FA() {
    // 2FA toggle functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Two-factor authentication feature coming soon'),
      ),
    );
  }

  // Edit Profile functionality
  void _editProfile() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _EditProfileDialog(dataManager: _dataManager),
    );

    if (result == true) {
      // Profile was updated, refresh data
      await _dataManager.refreshUserData();
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text(
            'Password change functionality would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data download started')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion initiated'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.errorPrimary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Edit Profile Dialog Widget
class _EditProfileDialog extends StatefulWidget {
  final LocalDataManager dataManager;

  const _EditProfileDialog({required this.dataManager});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final userData = widget.dataManager.userData;
    _firstNameController =
        TextEditingController(text: userData?.firstName ?? '');
    _lastNameController = TextEditingController(text: userData?.lastName ?? '');
    _userNameController = TextEditingController(text: userData?.userName ?? '');
    _phoneController = TextEditingController(text: userData?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final currentUserData = widget.dataManager.userData;
      final userId = widget.dataManager.currentUserId;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Clean phone number (digits only)
      final cleanPhone =
          _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');

      // Create updated user data
      final updatedUserData = currentUserData?.copyWith(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            userName: _userNameController.text.trim().isEmpty
                ? null
                : _userNameController.text.trim(),
            phoneNumber: cleanPhone.isEmpty ? null : cleanPhone,
          ) ??
          UserData(
            id: '',
            createdAt: DateTime.now(),
            userUuid: userId,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            userName: _userNameController.text.trim().isEmpty
                ? null
                : _userNameController.text.trim(),
            phoneNumber: cleanPhone.isEmpty ? null : cleanPhone,
          );

      await widget.dataManager.saveUserData(updatedUserData);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: TColors.primary,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $error'),
            backgroundColor: TColors.errorPrimary,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? TColors.surfaceDark : Colors.white;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.3),
              blurRadius: isDark ? 20 : 15,
              offset: const Offset(0, 10),
              spreadRadius: isDark ? 2 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern Header with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            TColors.primaryDark,
                            TColors.primaryDark.withValues(alpha: 0.8),
                          ]
                        : [
                            TColors.primary,
                            TColors.primary.withValues(alpha: 0.8),
                          ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TColors.textWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.userPen,
                        color: TColors.textWhite,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Edit Profile',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: TColors.textWhite,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: TColors.textWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: FaIcon(
                          FontAwesomeIcons.xmark,
                          color: TColors.textWhite,
                          size: 18,
                        ),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // First Name
                          _buildModernTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            icon: FontAwesomeIcons.user,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),

                          // Last Name
                          _buildModernTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            icon: FontAwesomeIcons.user,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),

                          // Username (Optional)
                          _buildModernTextField(
                            controller: _userNameController,
                            label: 'Username',
                            icon: FontAwesomeIcons.userTag,
                            isOptional: true,
                            validator: (value) {
                              if (value != null &&
                                  value.trim().isNotEmpty &&
                                  value.trim().length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              return null;
                            },
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),

                          // Phone Number
                          _buildModernTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: FontAwesomeIcons.mobile,
                            keyboardType: TextInputType.phone,
                            isOptional: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final phone = value
                                    .trim()
                                    .replaceAll(RegExp(r'[^\d]'), '');
                                if (phone.length != 10) {
                                  return 'Please enter exactly 10 digits';
                                }
                              }
                              return null;
                            },
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? TColors.surfaceDark.withValues(alpha: 0.5)
                      : Colors.grey.withValues(alpha: 0.05),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? TColors.textSecondaryDark.withValues(alpha: 0.2)
                          : TColors.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernButton(
                        text: 'Cancel',
                        onPressed:
                            _isSaving ? null : () => Navigator.pop(context),
                        isOutlined: true,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernButton(
                        text: 'Save',
                        onPressed: _isSaving ? null : _saveProfile,
                        isLoading: _isSaving,
                        isDark: isDark,
                      ),
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

  // Modern text field with theme adaptation
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    String? helperText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    // Create the label with optional indicator
    final displayLabel = isOptional ? '$label (Optional)' : label;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: displayLabel,
        helperText: helperText,
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.3)
            : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // Modern button with theme adaptation
  Widget _buildModernButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isDark,
    bool isOutlined = false,
    bool isLoading = false,
  }) {
    final primaryColor = isDark ? TColors.primaryDark : TColors.primary;

    if (isOutlined) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? TColors.textSecondaryDark.withValues(alpha: 0.5)
                : TColors.textSecondary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isDark ? TColors.textPrimaryDark : TColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: onPressed != null
              ? [primaryColor, primaryColor.withValues(alpha: 0.8)]
              : [
                  (isDark ? TColors.textSecondaryDark : TColors.textSecondary)
                      .withValues(alpha: 0.3),
                  (isDark ? TColors.textSecondaryDark : TColors.textSecondary)
                      .withValues(alpha: 0.2),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        TColors.textWhite,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: TColors.textWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
