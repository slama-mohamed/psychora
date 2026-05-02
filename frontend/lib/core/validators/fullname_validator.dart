import 'validation_patterns.dart';
import 'validation_messages.dart';

/// Validateur pour les champs full name
class FullNameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.emptyFullName;
    }
    return null;
  }

  static bool isValid(String fullName) {
    return ValidationPatterns.isValidFullName(fullName);
  }
}
