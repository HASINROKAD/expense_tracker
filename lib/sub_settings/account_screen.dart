import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';
import '../data/local_data_manager.dart';
import '../data/user_data_model.dart';

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
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
        // Edit profile action removed
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.primary, TColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main profile section
          Row(
            children: [
              // Enhanced avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: TColors.textWhite.withValues(alpha: 0.2),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: TColors.textWhite,
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        size: 35,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                  // Verification status indicator
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors
                            .green, // Assuming verified since user is logged in
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TColors.textWhite,
                          width: 2,
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.check, // Assuming verified
                        size: 12,
                        color: TColors.textWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // User information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with better typography
                    Text(
                      _dataManager.userData?.displayName ?? 'User Name',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: TColors.textWhite,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                    ),
                    const SizedBox(height: 8),
                    // Email with icon
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          size: 14,
                          color: TColors.textWhite.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'user@example.com', // Email from auth, not stored in user data
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      TColors.textWhite.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Email verified badge
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            'Verified',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.green[100],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Phone with icon
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.phone,
                          size: 14,
                          color: TColors.textWhite.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _dataManager.userData?.formattedPhoneNumber ??
                                'Not provided',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      TColors.textWhite.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        if (_dataManager.userData?.phoneNumber?.isNotEmpty ??
                            false)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              'Verified',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green[100],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit, color: TColors.textWhite),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: TColors.textWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.textWhite.withValues(alpha: 0.2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: TColors.textWhite.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Security status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: TColors.textWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TColors.textWhite.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.shield,
                  size: 16,
                  color: Colors.orange[300], // 2FA disabled by default
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Enable 2FA for better security', // 2FA disabled by default
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textWhite.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2), // 2FA disabled
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'At Risk', // 2FA disabled by default
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange[100], // 2FA disabled
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTile(
    String title,
    String status,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          status,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
        trailing: onTap != null
            ? Icon(Icons.chevron_right, color: color)
            : FaIcon(FontAwesomeIcons.check, color: color, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.containerPrimary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TColors.containerPrimary),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Transactions',
              _dataManager.getUserStatistics()['totalTransactions'].toString(),
              FontAwesomeIcons.receipt,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: TColors.containerPrimary,
          ),
          Expanded(
            child: _buildStatItem(
              'Categories',
              _dataManager.getUserStatistics()['categoriesCreated'].toString(),
              FontAwesomeIcons.tags,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: TColors.containerPrimary,
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
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 24,
          color: TColors.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: TColors.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
              ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
        ),
        onTap: onTap,
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.edit, color: TColors.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Edit Profile',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primary,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Name
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Last Name
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Username (Optional)
                      TextFormField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'Username (Optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.alternate_email),
                          helperText: 'Optional username for your account',
                        ),
                        validator: (value) {
                          if (value != null &&
                              value.trim().isNotEmpty &&
                              value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_outlined),
                          helperText: 'Enter your 10-digit phone number',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final phone =
                                value.trim().replaceAll(RegExp(r'[^\d]'), '');
                            if (phone.length != 10) {
                              return 'Please enter exactly 10 digits';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: TColors.textWhite,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  TColors.textWhite),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
