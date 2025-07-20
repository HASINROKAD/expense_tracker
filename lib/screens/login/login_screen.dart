import 'package:expense_tracker/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/supabase_auth.dart';
import '../../utils/constants/colors.dart';
import '../../validators/custom_validator.dart';
import '../register/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation
  bool _obscurePassword = true; // For password visibility toggle

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 100.0, right: 24.0, bottom: 24.0, left: 24.0),
          child: Column(
            children: [
              /// logo,title, subtitle
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    height: 130,
                    image:
                        AssetImage('assets/images/expense_tracker_logo.jpeg'),
                  ),
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Peace of Mind, One Expense at a Time.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              ///Form
              Form(
                key: _formKey, // Assign form key
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.envelope,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.primaryDark
                                    : TColors.primary,
                          ),
                          labelText: 'E-Mail',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: validateEmail, // Use email validator
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.lock,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.primaryDark
                                    : TColors.primary,
                          ),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TColors.primaryDark
                                  : TColors.primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: validatePassword, // Use password validator
                      ),
                      const SizedBox(height: 8.0),

                      /// Remember me & Forget Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ///Forget Password
                          TextButton(
                            style: TextButton.styleFrom(
                              overlayColor: TColors.containerPrimary,
                            ),
                            onPressed: () {
                              // Show forgot password dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Forgot Password'),
                                  content: const Text(
                                    'Password reset functionality will be implemented soon. Please contact support if you need assistance.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text('Forget password'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28.0),

                      ///Log in Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.primaryDark
                                    : TColors.containerPrimary,
                            foregroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? TColors.textWhite
                                    : TColors.primary,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final navigator = Navigator.of(context);
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final isDark = Theme.of(context).brightness ==
                                  Brightness.dark;
                              final client = SupabaseAuth.client();

                              try {
                                final AuthResponse res =
                                    await client.auth.signInWithPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );

                                if (res.user != null && mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: const Text('Sign In Successful'),
                                      backgroundColor: isDark
                                          ? TColors.primaryDark
                                          : TColors.primary,
                                    ),
                                  );
                                  navigator.pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => MainNavigation(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text('please create an account'),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 14.0),

                      ///Create Account Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: TColors.primary),
                              foregroundColor: TColors.primary),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text('Create Account'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
