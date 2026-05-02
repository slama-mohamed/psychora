class EndPointUrl {
  EndPointUrl._();

  static const String login = '/api/psy/login';
  static const String logout = '/api/psy/logout';
  static const String signup = '/api/psy/signup';
  static const String forgotPassword = '/api/psy/forgot-password';
  static const String resetPassword = '/api/psy/reset-password';
  static const String currentUser = '/api/psy/users/me';
  static const String addPatient = '/api/psy/patients';
  static const String patientsNotes = '/api/psy/patients/notes';
  static const String chatbotMessage = '/api/psy/conversations/message';
  static const String patientConversation = '/api/psy/conversations';

  // Student Chat Endpoints
  static const String studentMessage = '/api/psy/student/message';
  static const String studentMessages = '/api/psy/student/messages';
  static const String clearStudentMessages = '/api/psy/student/messages';
}