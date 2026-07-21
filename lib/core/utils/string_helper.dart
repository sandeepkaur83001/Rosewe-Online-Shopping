class StringHelper {
  /// Capitalize the first letter of a string
  /// Example: "hello world" -> "Hello world"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Convert string to Title Case
  /// Example: "hello world" -> "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Truncate string with ellipsis
  /// Example: "This is a long text", 10 -> "This is a..."
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + suffix;
  }

  /// Mask email for privacy
  /// Example: "example@gmail.com" -> "e******@gmail.com"
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    if (name.length <= 1) return email;
    return '${name[0]}${'*' * (name.length - 1)}@${parts[1]}';
  }

  /// Mask phone number
  /// Example: "1234567890" -> "******7890"
  static String maskPhone(String phone, {int visibleDigits = 4}) {
    if (phone.length <= visibleDigits) return phone;
    final maskLength = phone.length - visibleDigits;
    return '${'*' * maskLength}${phone.substring(maskLength)}';
  }

  /// Remove all whitespace from a string
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if a string is numeric
  static bool isNumeric(String? s) {
    if (s == null) return false;
    return double.tryParse(s) != null;
  }

  /// Extract initials from a name
  /// Example: "John Doe" -> "JD"
  static String getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[nameParts.length - 1][0]).toUpperCase();
    } else {
      return nameParts[0][0].toUpperCase();
    }
  }
}
