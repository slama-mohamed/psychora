import 'validation_patterns.dart';
import 'validation_messages.dart';

/// Validateur pour les champs email
class EmailValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.emptyEmail;
    }
    if (!ValidationPatterns.isValidEmail(value)) {
      return ValidationMessages.invalidEmail;
    }
    return null;
  }

  static bool isValid(String email) {
    return email.isNotEmpty && ValidationPatterns.isValidEmail(email);
  }
}
