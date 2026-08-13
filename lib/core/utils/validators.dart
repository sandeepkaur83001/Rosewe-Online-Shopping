class Validators {
  Validators._();

  /// Required Field
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Password
  static String? password(
      String? value, {
        int minLength = 8,
      }) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Rosewe specific password validation
  /// Password must contain 6 characters minimum and at least 1 letter.
  static String? validateRosewePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }

    return null;
  }

  /// Strong Password
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }

    return null;
  }

  /// Confirm Password
  static String? confirmPassword(
      String? password,
      String? confirmPassword,
      ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Phone Number
  static String? phone(
      String? value, {
        int minLength = 10,
        int maxLength = 15,
      }) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phone = value.trim();

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must contain digits only';
    }

    if (phone.length < minLength || phone.length > maxLength) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  /// Name
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  /// Username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    final regex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!regex.hasMatch(value.trim())) {
      return 'Only letters, numbers and underscores are allowed';
    }

    return null;
  }

  /// URL
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value.trim());

    if (uri == null || !(uri.hasScheme && uri.hasAuthority)) {
      return 'Enter a valid URL';
    }

    return null;
  }

  /// OTP
  static String? otp(
      String? value, {
        int length = 6,
      }) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }

    if (value.length != length) {
      return 'OTP must be $length digits';
    }

    return null;
  }

  /// Minimum Length
  static String? minLength(
      String? value,
      int length,
      String fieldName,
      ) {
    if (value == null || value.length < length) {
      return '$fieldName must be at least $length characters';
    }

    return null;
  }

  /// Maximum Length
  static String? maxLength(
      String? value,
      int length,
      String fieldName,
      ) {
    if (value != null && value.length > length) {
      return '$fieldName cannot exceed $length characters';
    }

    return null;
  }

  /// Numeric Only
  static String? number(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return '$fieldName must contain only numbers';
    }

    return null;
  }

  /// Age
  static String? age(
      String? value, {
        int minAge = 18,
      }) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);

    if (age == null) {
      return 'Enter a valid age';
    }

    if (age < minAge) {
      return 'Age must be at least $minAge';
    }

    return null;
  }
}