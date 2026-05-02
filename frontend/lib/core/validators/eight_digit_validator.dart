import 'validation_patterns.dart';
import 'validation_messages.dart';

/// Validateur pour les champs nécessitant 8 chiffres numériques
/// Utilisé pour: ID card, phone number, etc.
class EightDigitValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.fieldRequired;
    }
    if (!ValidationPatterns.isValidIdCard(value)) {
      return 'Must be 8 numeric digits';
    }
    return null;
  }
}
