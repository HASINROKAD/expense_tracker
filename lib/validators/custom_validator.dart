String? validateFirstName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your first name';
  }
  if (value.trim().length < 2) {
    return 'First name must be at least 2 characters long';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
    return 'First name can only contain letters and spaces';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your last name';
  }
  if (value.trim().length < 2) {
    return 'Last name must be at least 2 characters long';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
    return 'Last name can only contain letters and spaces';
  }
  return null;
}

String? validateUserName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a username';
  }
  if (value.trim().length < 3) {
    return 'Username must be at least 3 characters long';
  }
  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
    return 'Username can only contain letters, numbers, and underscores';
  }
  return null;
}

String? validateMobileNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your mobile number';
  }
  if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value.trim())) {
    return 'Please enter a valid mobile number';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a password';
  }
  if (value.trim().length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
      .hasMatch(value.trim())) {
    return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
  }
  return null;
}


// form expense income validators
String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an amount';
  }
  if (double.tryParse(value) == null || double.parse(value) <= 0) {
    return 'Please enter a valid positive number';
  }
  return null;
}

String? validatePayee(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a payee name';
  }
  return null;
}

String? validatePayer(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a payer name';
  }
  return null;
}

String? validateCategory(String? value) {
  if (value == null) {
    return 'Please select a category';
  }
  return null;
}

String? validatePaymentMethod(String? value) {
  if (value == null) {
    return 'Please select a payment method';
  }
  return null;
}

String? validatePaymentStatus(String? value) {
  if (value == null) {
    return 'Please select a payment status';
  }
  return null;
}

String? validateDate(DateTime? date) {
  if (date == null) {
    return 'Please select a date';
  }
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selected = DateTime(date.year, date.month, date.day);
  if (selected.isAfter(today)) {
    return 'Future dates are not allowed';
  }
  return null;
}