import 'package:flutter/material.dart';

class DropdownStyle {
  static ButtonStyle getDropdownButtonStyle() {
    return ButtonStyle(
      // Background color of the button
      backgroundColor: WidgetStateProperty.all<Color>(
        Colors.white,
      ),
      // Enhanced border styling
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Colors.grey.shade600, // Darker border color for emphasis
            width: 2.0, // Thicker border for visibility
          ),
        ),
      ),
      // Padding inside the button
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      // Text style for the selected item
      textStyle: WidgetStateProperty.all<TextStyle>(
        TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      // Elevation for a subtle shadow effect
      elevation: WidgetStateProperty.all<double>(2.0),
      // Hover effect
      overlayColor: WidgetStateProperty.all<Color>(
        Colors.grey.shade100,
      ),
    );
  }

  // Style for dropdown menu items
  static TextStyle getDropdownMenuItemStyle() {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
  }

  // Style for the dropdown menu itself with border
  static BoxDecoration getDropdownMenuDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: Colors.grey.shade600, // Matching border color
        width: 2.0, // Matching border width
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          spreadRadius: 1,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}