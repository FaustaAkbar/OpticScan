// API Constants for OpticScan App

class ApiConstants {
  // Base URLs
  static const String baseUrlEmulator =
      'https://intellisight.humicprototyping.com'; // nanti ganti dengan base url server

  // Auth endpoints
  static const String loginEndpoint = '/auth/login'; // POST
  static const String registerEndpoint = '/auth/register'; // POST
  static const String logoutEndpoint = '/auth/logout'; // GET
  static const String refreshEndpoint = '/auth/refresh'; // GET
  static const String userInfoEndpoint = '/auth/me'; // GET

  // Examination endpoints
  static const String getExamResultsEndpoint = '/exam/my-result'; // GET
  static const String submitExamEndpoint =
      '/exam/submit-exam'; // POST (dengan file upload)
  static const String diagnosisDokterEndpoint =
      '/exam/diagnosis-dokter'; // POST

  // Profile endpoints
  static const String getUserProfileEndpoint = '/user/profile'; // GET
  static const String updateUserProfileEndpoint = '/user/profile'; // PATCH
  static const String changePasswordEndpoint = '/user/change-password'; // PATCH
  static const String changeProfilePicEndpoint =
      '/user/change-profile-pic'; // PATCH (dengan file upload)

  // User statistics endpoints
  static const String getUsersCountEndpoint = '/user/users-count'; // GET

  // Url untuk images
  static const String eyeImageBaseUrl = '/images/eye-scans';
  static const String profileImageBaseUrl = '/images/profile-pics';
  static const String defaultProfileImage = 'blank-profile-pic.png';

  // Simpan keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
}
