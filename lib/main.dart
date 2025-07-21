import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expense_tracker/screens/login/login_screen.dart';
import 'package:expense_tracker/theme/theme_manager.dart';
import 'package:expense_tracker/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/supabase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_onThemeChanged);
    _themeManager.initialize();
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: _themeManager.themeMode,
      theme: _themeManager.lightTheme,
      darkTheme: _themeManager.darkTheme,
      home: AnimatedSplashScreen(
        splash: 'assets/images/expense_tracker_logo.jpeg',
        splashIconSize: 2000.0,
        centered: true,
        backgroundColor: Colors.white,
        duration: 150,
        nextScreen: const AuthCheckScreen(),
      ),
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final client = SupabaseAuth.client();
    final isLoggedIn = client.auth.currentSession != null;

    // Redirect to MainNavigation if logged in, else LoginScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLoggedIn ? const MainNavigation() : const LoginScreen(),
        ),
      );
    });

    // Show a blank screen or loading indicator during the check
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
