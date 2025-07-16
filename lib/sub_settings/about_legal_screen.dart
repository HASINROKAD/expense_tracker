import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/constants/colors.dart';

class AboutLegalScreen extends StatelessWidget {
  const AboutLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Legal'),
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Card
            _buildAppInfoCard(context),
            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader(context, 'About'),
            _buildInfoTile(
              context,
              'Version',
              '1.2.3 (Build 456)',
              FontAwesomeIcons.tag,
              TColors.primary,
            ),
            _buildInfoTile(
              context,
              'Release Date',
              'March 2024',
              FontAwesomeIcons.calendar,
              TColors.primary,
            ),
            _buildInfoTile(
              context,
              'Platform',
              'Flutter 3.19.0',
              FontAwesomeIcons.mobile,
              TColors.primary,
            ),
            const SizedBox(height: 24),

            // Developer Section
            _buildSectionHeader(context, 'Developer'),
            _buildActionTile(
              context,
              'Developer Website',
              'Visit our official website',
              FontAwesomeIcons.globe,
              TColors.primary,
              () => _openUrl('https://developer-website.com'),
            ),
            _buildActionTile(
              context,
              'Contact Support',
              'Get help and support',
              FontAwesomeIcons.envelope,
              TColors.secondary,
              () => _contactSupport(context),
            ),
            _buildActionTile(
              context,
              'Rate App',
              'Rate us on the app store',
              FontAwesomeIcons.star,
              Colors.orange,
              () => _rateApp(context),
            ),
            _buildActionTile(
              context,
              'Share App',
              'Share with friends and family',
              FontAwesomeIcons.share,
              TColors.tertiary,
              () => _shareApp(context),
            ),
            const SizedBox(height: 24),

            // Legal Section
            _buildSectionHeader(context, 'Legal'),
            _buildActionTile(
              context,
              'Terms of Service',
              'Read our terms and conditions',
              FontAwesomeIcons.fileContract,
              TColors.primary,
              () => _showTermsOfService(context),
            ),
            _buildActionTile(
              context,
              'Privacy Policy',
              'Learn how we protect your data',
              FontAwesomeIcons.userShield,
              TColors.secondary,
              () => _showPrivacyPolicy(context),
            ),
            _buildActionTile(
              context,
              'Open Source Licenses',
              'View third-party licenses',
              FontAwesomeIcons.code,
              TColors.tertiary,
              () => _showLicenses(context),
            ),

            const SizedBox(height: 24),

            // Social Media Section
            _buildSectionHeader(context, 'Connect With Us'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.twitter,
                  Colors.blue,
                  () => _openSocial('twitter'),
                ),
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.facebook,
                  Colors.blue.shade800,
                  () => _openSocial('facebook'),
                ),
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.instagram,
                  Colors.purple,
                  () => _openSocial('instagram'),
                ),
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.linkedin,
                  Colors.blue.shade700,
                  () => _openSocial('linkedin'),
                ),
                _buildSocialButton(
                  context,
                  FontAwesomeIcons.github,
                  Colors.black,
                  () => _openSocial('github'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Credits Section
            _buildSectionHeader(context, 'Credits'),
            _buildCreditsTile(
              context,
              'Framework',
              'Flutter by Google',
              FontAwesomeIcons.mobile,
            ),
            _buildCreditsTile(
              context,
              'Backend',
              'Supabase',
              FontAwesomeIcons.database,
            ),
            const SizedBox(height: 32),

            // Copyright
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2024 Expense Tracker',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All rights reserved',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Made with ❤️ for better expense tracking',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
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

  Widget _buildAppInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColors.primary,
            TColors.primary.withValues(alpha: 0.8),
            TColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: TColors.secondary.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced app icon with multiple layers
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow effect
              Container(
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
                  ),
                ),
              ),
              // Main icon container
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: TColors.textWhite.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: TColors.textWhite.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.textWhite.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: FaIcon(
                  FontAwesomeIcons.chartLine,
                  size: 40,
                  color: TColors.textWhite,
                ),
              ),
              // Inner highlight
              Positioned(
                top: 8,
                left: 20,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: TColors.textWhite.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: TColors.textWhite.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // App name with enhanced typography
          Text(
            'Expense Tracker',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: TColors.textWhite,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: TColors.primary.withValues(alpha: 0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Enhanced tagline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your Smart Personal Finance Companion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: TColors.textWhite.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Enhanced version badge and features
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Version badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: TColors.textWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: TColors.textWhite.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TColors.textWhite.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tag,
                      size: 12,
                      color: TColors.textWhite.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'v1.2.3',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.textWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Latest',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green[100],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Feature highlights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TColors.textWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TColors.textWhite.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureItem(
                  context,
                  FontAwesomeIcons.shield,
                  'Secure',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: TColors.textWhite.withValues(alpha: 0.3),
                ),
                _buildFeatureItem(
                  context,
                  FontAwesomeIcons.bolt,
                  'Fast',
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: TColors.textWhite.withValues(alpha: 0.3),
                ),
                _buildFeatureItem(
                  context,
                  FontAwesomeIcons.solidHeart,
                  'Loved',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 16,
          color: TColors.textWhite.withValues(alpha: 0.9),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textWhite.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
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
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
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

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: FaIcon(
          icon,
          size: 24,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCreditsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
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
            color: TColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            size: 20,
            color: TColors.primary,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TColors.textSecondary,
              ),
        ),
      ),
    );
  }

  // Action handlers
  void _openUrl(String url) {
    // In a real app, you would use url_launcher package
    // launch(url);
  }

  void _contactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@expensetracker.com'),
            SizedBox(height: 8),
            Text('Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('Hours: Mon-Fri 9AM-5PM EST'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open email client
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.secondary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _rateApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Our App'),
        content: const Text(
          'We hope you\'re enjoying Expense Tracker! Would you like to rate us on the app store?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open app store
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share App'),
        content: const Text(
          'Share Expense Tracker with your friends and family!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open share dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.tertiary,
              foregroundColor: TColors.textWhite,
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'TERMS OF SERVICE\n\n'
            '1. ACCEPTANCE OF TERMS\n'
            'By using Expense Tracker, you agree to these terms.\n\n'
            '2. USE OF SERVICE\n'
            'You may use this app for personal expense tracking.\n\n'
            '3. PRIVACY\n'
            'We respect your privacy and protect your data.\n\n'
            '4. LIMITATION OF LIABILITY\n'
            'We are not liable for any damages from app usage.\n\n'
            '5. CHANGES TO TERMS\n'
            'We may update these terms at any time.\n\n'
            'For complete terms, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'PRIVACY POLICY\n\n'
            '1. INFORMATION WE COLLECT\n'
            'We collect expense data you enter and usage analytics.\n\n'
            '2. HOW WE USE INFORMATION\n'
            'Your data is used to provide expense tracking services.\n\n'
            '3. DATA SHARING\n'
            'We do not sell or share your personal data.\n\n'
            '4. DATA SECURITY\n'
            'We use encryption to protect your information.\n\n'
            '5. YOUR RIGHTS\n'
            'You can export or delete your data at any time.\n\n'
            'For complete policy, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Source Licenses'),
        content: const SingleChildScrollView(
          child: Text(
            'THIRD-PARTY LICENSES\n\n'
            'Flutter Framework\n'
            'Copyright (c) Google Inc.\n'
            'BSD 3-Clause License\n\n'
            'FontAwesome Icons\n'
            'Copyright (c) Fonticons, Inc.\n'
            'CC BY 4.0 License\n\n'
            'Supabase\n'
            'Copyright (c) Supabase Inc.\n'
            'Apache 2.0 License\n\n'
            'And other open source libraries...\n\n'
            'For complete license information, visit our website.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openSocial(String platform) {
    // In a real app, you would open the respective social media app/website
    // For now, just show a message
  }
}
