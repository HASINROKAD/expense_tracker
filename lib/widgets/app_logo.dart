import 'package:flutter/material.dart';

/// App Logo Widget
/// 
/// A reusable widget that displays the application logo from assets.
/// Can be used throughout the app wherever the logo is needed.
class AppLogo extends StatelessWidget {
  /// Creates an AppLogo widget.
  /// 
  /// [width] - Optional width for the logo (defaults to 120)
  /// [height] - Optional height for the logo (defaults to 120)
  /// [fit] - How the image should be inscribed into the space (defaults to BoxFit.contain)
  const AppLogo({
    super.key,
    this.width = 120,
    this.height = 120,
    this.fit = BoxFit.contain,
  });

  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/expense_tracker_logo.jpeg',
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Fallback widget if image fails to load
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: width * 0.4,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Small App Logo Widget
/// 
/// A smaller version of the app logo for use in app bars, headers, etc.
class AppLogoSmall extends StatelessWidget {
  const AppLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(
      width: 40,
      height: 40,
    );
  }
}

/// Medium App Logo Widget
/// 
/// A medium-sized version of the app logo for use in cards, dialogs, etc.
class AppLogoMedium extends StatelessWidget {
  const AppLogoMedium({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(
      width: 80,
      height: 80,
    );
  }
}

/// Large App Logo Widget
/// 
/// A large version of the app logo for use in splash screens, welcome screens, etc.
class AppLogoLarge extends StatelessWidget {
  const AppLogoLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(
      width: 200,
      height: 200,
    );
  }
}

/// Circular App Logo Widget
/// 
/// A circular version of the app logo with rounded edges.
class AppLogoCircular extends StatelessWidget {
  /// Creates a circular AppLogo widget.
  /// 
  /// [size] - The diameter of the circular logo (defaults to 100)
  const AppLogoCircular({
    super.key,
    this.size = 100,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/expense_tracker_logo.jpeg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback widget if image fails to load
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: size * 0.4,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
