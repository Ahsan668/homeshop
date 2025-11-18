/// API Constants for Platzi Fake Store API
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  // API Endpoints
  static const String products = '/products';
  static const String categories = '/categories';
  static const String users = '/users';
  static const String auth = '/auth';
  static const String files = '/files';

  // Auth Endpoints
  static const String login = '$auth/login';
  static const String profile = '$auth/profile';
  static const String refreshToken = '$auth/refresh-token';

  // Product Endpoints
  static String productById(int id) => '$products/$id';
  static String productsByCategory(int categoryId) =>
      '$products/?categoryId=$categoryId';

  // Category Endpoints
  static String categoryById(int id) => '$categories/$id';

  // User Endpoints
  static String userById(int id) => '$users/$id';

  // File Upload
  static const String uploadFile = '$files/upload';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Timeouts (in milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
