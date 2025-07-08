import 'package:expense_tracker/theme/custom_theme/text_theme.dart';
import 'package:expense_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  //light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'lato',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
  );

  //dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'lato',
    brightness: Brightness.dark,
    primaryColor: TColors.primaryDark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
  );
}
