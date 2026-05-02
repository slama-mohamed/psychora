/// Patterns de validation réutilisables
class ValidationPatterns {
  /// Regex pour valider un email
  static const String emailPattern =
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// Validation email
  static bool isValidEmail(String email) {
    return RegExp(emailPattern).hasMatch(email);
  }

  /// Validation password (min 8 caractères)
  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  /// Validation nom complet (non vide, trimmed)
  static bool isValidFullName(String fullName) {
    return fullName.trim().isNotEmpty;
  }

  /// Validation générique non vide
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validation 8 chiffres numériques (ID card, phone, etc.)
  static bool isValidIdCard(String idCard) {
    return RegExp(r'^\d{8}$').hasMatch(idCard);
  }

  /// Alias pour isValidIdCard (même validation: 8 chiffres)
  static bool isValidPhone(String phone) {
    return isValidIdCard(phone);
  }
}
