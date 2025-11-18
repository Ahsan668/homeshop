/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'HomeShop';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeMode = 'theme_mode';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;

  // Animation Durations (in milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Image Placeholders
  static const String placeholderImage =
      'https://via.placeholder.com/300x300.png?text=No+Image';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  // Error Messages
  static const String genericError =
      'Something went wrong. Please try again later.';
  static const String networkError =
      'Network error. Please check your internet connection.';
  static const String authError = 'Authentication failed. Please login again.';
}
