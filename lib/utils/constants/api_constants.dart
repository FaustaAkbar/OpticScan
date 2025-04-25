// API Constants for OpticScan App

class ApiConstants {
  // Base URLs
  static const String baseUrlEmulator =
      'https://ws1qtsds-4000.asse.devtunnels.ms';

  // Auth endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshEndpoint = '/auth/refresh';
  static const String userInfoEndpoint = '/auth/me';

  // Examination endpoints
  static const String getExamResultsEndpoint = '/exam/my-result';
  static const String submitExamEndpoint = '/exam/submit-exam';
  static const String diagnosisDokterEndpoint = '/exam/diagnosis-dokter';

  // Profile endpoints
  static const String getUserProfileEndpoint = '/user/profile';
  static const String updateUserProfileEndpoint = '/user/profile';
  static const String changePasswordEndpoint = '/user/change-password';
  static const String changeProfilePicEndpoint = '/user/change-profile-pic';

  // Base URLs for images
  static const String eyeImageBaseUrl =
      'https://ws1qtsds-4000.asse.devtunnels.ms/images/eye-scans/';
  static const String profileImageBaseUrl =
      'https://ws1qtsds-4000.asse.devtunnels.ms/images/profile-pics/';
  static const String defaultProfileImage = 'blank-profile-pic.png';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
}
