/// Hive box names and constants for local storage
class HiveConstants {
  // Box Names
  static const String cartBox = 'cart_box';
  static const String favoritesBox = 'favorites_box';
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';

  // Type IDs for Hive Adapters
  static const int cartItemTypeId = 0;
  static const int productTypeId = 1;
  static const int categoryTypeId = 2;
  static const int userTypeId = 3;

  // Private constructor to prevent instantiation
  HiveConstants._();
}
