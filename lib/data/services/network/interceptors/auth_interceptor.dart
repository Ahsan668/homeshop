import 'package:dio/dio.dart';
import 'package:homeshop/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor for adding authentication tokens to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(AppConstants.accessTokenKey);

    // Add token to request headers if available
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _refreshToken(err.requestOptions);

      if (refreshed) {
        // Retry the request with new token
        try {
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.reject(e);
        }
      } else {
        // Clear tokens and redirect to login
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(AppConstants.accessTokenKey);
        await prefs.remove(AppConstants.refreshTokenKey);
        await prefs.setBool(AppConstants.isLoggedInKey, false);
      }
    }

    super.onError(err, handler);
  }

  Future<bool> _refreshToken(RequestOptions requestOptions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.refreshTokenKey);

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Make refresh token request
      final response = await Dio().post(
        'https://api.escuelajs.co/api/v1/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        // Save new tokens
        await prefs.setString(AppConstants.accessTokenKey, newAccessToken);
        await prefs.setString(AppConstants.refreshTokenKey, newRefreshToken);

        // Update request headers with new token
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
