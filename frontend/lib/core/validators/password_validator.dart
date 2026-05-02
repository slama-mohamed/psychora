import 'validation_patterns.dart';
import 'validation_messages.dart';

/// Validateur pour les champs password
class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.emptyPassword;
    }
    if (!ValidationPatterns.isValidPassword(value)) {
      return ValidationMessages.shortPassword;
    }
    return null;
  }

  static bool isValid(String password) {
    return password.isNotEmpty && ValidationPatterns.isValidPassword(password);
  }
}
