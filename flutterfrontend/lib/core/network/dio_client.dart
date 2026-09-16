import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class DioClient {
  late final Dio _dio;
  String? _accessToken;
  String? _refreshToken;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && _refreshToken != null) {
          try {
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              error.requestOptions.headers['Authorization'] = 'Bearer $_accessToken';
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          } catch (_) {
            _accessToken = null;
            _refreshToken = null;
          }
        }
        handler.next(error);
      },
    ));
  }

  void setTokens({required String accessToken, String? refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  String? get accessToken => _accessToken;

  Future<bool> _refreshAccessToken() async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refresh': _refreshToken},
      );
      if (response.statusCode == 200) {
        _accessToken = response.data['access'];
        _refreshToken = response.data['refresh'] ?? _refreshToken;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> upload(String path, FormData formData) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    String message;
    int? statusCode = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out. Please try again.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.badResponse:
        message = _parseServerError(e.response?.data);
        break;
      default:
        message = 'An unexpected error occurred.';
    }

    return ApiException(message: message, statusCode: statusCode, data: e.response?.data);
  }

  String _parseServerError(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? 'Server error occurred.';
    }
    return 'Server error occurred.';
  }
}
