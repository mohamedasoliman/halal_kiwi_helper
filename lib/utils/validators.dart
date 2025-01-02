// lib/utils/validators.dart
class Validators {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    if (!urlPattern.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final phonePattern = RegExp(r'^\+?[\d\s-]+$');
    if (!phonePattern.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}