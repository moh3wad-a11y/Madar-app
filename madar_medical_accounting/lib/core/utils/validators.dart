class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Amount must be present, numeric, and >= 0 (section 22: "Amount cannot be negative").
  static String? nonNegativeAmount(String? value, {String fieldName = 'Amount'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', ''));
    if (parsed == null) {
      return '$fieldName must be a valid number';
    }
    if (parsed < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }

  static String? positiveAmount(String? value, {String fieldName = 'Amount'}) {
    final baseError = nonNegativeAmount(value, fieldName: fieldName);
    if (baseError != null) return baseError;
    final parsed = double.parse(value!.trim().replaceAll(',', ''));
    if (parsed <= 0) {
      return '$fieldName must be greater than zero';
    }
    return null;
  }

  /// Discount cannot exceed the gross amount it applies to.
  static String? discountNotExceedingGross(String? discountValue, double grossAmount) {
    if (discountValue == null || discountValue.trim().isEmpty) return null;
    final parsed = double.tryParse(discountValue.trim().replaceAll(',', ''));
    if (parsed == null) return 'Discount must be a valid number';
    if (parsed < 0) return 'Discount cannot be negative';
    if (parsed > grossAmount) return 'Discount cannot exceed the gross amount';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 8) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
