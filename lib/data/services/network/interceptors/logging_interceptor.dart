import 'package:dio/dio.dart';
import 'package:homeshop/core/utils/logger.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info('REQUEST[${options.method}] => PATH: ${options.path}');
    AppLogger.debug('Headers: ${options.headers}');
    AppLogger.debug('QueryParameters: ${options.queryParameters}');
    if (options.data != null) {
      AppLogger.debug('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    AppLogger.debug('Response Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      err.message,
    );
    AppLogger.error('Error Type: ${err.type}');
    AppLogger.error('Error Message: ${err.message}');
    if (err.response != null) {
      AppLogger.error('Error Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
