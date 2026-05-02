import 'email_validator.dart';
import 'password_validator.dart';
import 'fullname_validator.dart';

/// Validateur de formulaire signup
class SignupFormValidator {
  /// Valide tous les champs du formulaire
  static bool validateAll({
    required String fullName,
    required String email,
    required String password,
  }) {
    return FullNameValidator.isValid(fullName) &&
        EmailValidator.isValid(email) &&
        PasswordValidator.isValid(password);
  }

  /// Valide individuellement et retourne les erreurs
  static Map<String, String?> validateAllWithMessages({
    required String fullName,
    required String email,
    required String password,
  }) {
    return {
      'fullName': FullNameValidator.validate(fullName),
      'email': EmailValidator.validate(email),
      'password': PasswordValidator.validate(password),
    };
  }
}
