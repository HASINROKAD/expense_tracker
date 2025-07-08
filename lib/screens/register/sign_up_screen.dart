import 'package:expense_tracker/data/supabase_auth.dart';
import 'package:expense_tracker/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/constants/colors.dart';
import '../../validators/custom_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // static const String keyFirstName = "firstName";
  // static const String keyLastName = "lastName";
  // static const String keyUserName = "userName";
  // static const String keyMobileNumber = "mobileNumber";
  // static const String keyEMail = "EMail";
  // static const String keyPassword = "password";

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  // String get name => firstNameController.text.trim();

  @override
  void dispose() {
    firstNameController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    emailController.dispose();
    userNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: 100.0, right: 24.0, bottom: 24.0, left: 24.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    height: 130,
                    image:
                        AssetImage('assets/images/expense_tracker_logo.jpeg'),
                  ),
                  Text(
                    ' ExpenseMate',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Let\'s create your account',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 18.0),

              ///Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        ///User's first and last Name
                        Expanded(
                          child: TextFormField(
                            controller: firstNameController,
                            expands: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.user),
                              labelText: 'First Name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: TColors.primary, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: validateFirstName,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: lastNameController,
                            expands: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.user),
                              labelText: 'Last Name',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: TColors.primary, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            validator: validateLastName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    ///Username
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.userPen),
                        labelText: 'User Name',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColors.primary, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: validateUserName,
                    ),
                    const SizedBox(height: 16.0),

                    ///Phone Number
                    TextFormField(
                      controller: mobileNumberController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.phone),
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColors.primary, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: validateMobileNumber,
                    ),
                    const SizedBox(height: 16.0),

                    ///E-Mail
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.envelope),
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColors.primary, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 16.0),

                    ///Password
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: TColors.primary, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16.0),

                    ///Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: TColors.containerPrimary,
                          foregroundColor: TColors.primary,
                        ),
                        onPressed: () async {
                          // var prefs = await SharedPreferences.getInstance();

                          // prefs.setString(keyFirstName, firstNameController.text.toString());
                          // prefs.setString(keyLastName, lastNameController.text.toString());
                          // prefs.setString(keyUserName, userNameController.text.toString());
                          // prefs.setString(keyMobileNumber, mobileNumberController.text.toString());
                          // prefs.setString(keyEMail, emailController.text.toString());
                          // prefs.setString(keyPassword, passwordController.text.toString());
                          if (_formKey.currentState!.validate()) {
                            final client = SupabaseAuth.client();
                            try {
                              final AuthResponse res = await client.auth.signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              if (res.user != null) {
                                final userId = client.auth.currentUser?.id;
                                if (userId == null) {
                                  throw Exception('No user is signed in');
                                }

                                await client.from('tbl_user_data').insert({
                                  'first_name': firstNameController.text.trim(),
                                  'user_uuid': userId,
                                  'last_name': lastNameController.text.trim(),
                                  'user_name': userNameController.text.trim(),
                                  'phone_number':
                                      mobileNumberController.text.trim(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Account created'),
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error creating account: $e'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Create Account'),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          overlayColor: TColors.containerPrimary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text('Already have account? Login'),
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
}
