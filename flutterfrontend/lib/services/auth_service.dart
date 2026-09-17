import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/user.dart';

class AuthService {
  final DioClient _dio;
  final FlutterSecureStorage _storage;
  User? _currentUser;

  AuthService({DioClient? dio})
      : _dio = dio ?? DioClient(),
        _storage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _dio.accessToken != null;

  Future<void> init() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      final refreshToken = await _storage.read(key: 'refresh_token');
      _dio.setTokens(accessToken: token, refreshToken: refreshToken);
      try {
        await getProfile();
      } catch (_) {
        await logout();
      }
    }
  }

  Future<User> login({required String username, required String password}) async {
    final response = await _dio.post(ApiConstants.login, data: {
      'username': username,
      'password': password,
    });
    final data = response.data;
    final tokens = data['tokens'];
    await _saveTokens(tokens['access'], tokens['refresh']);
    _currentUser = User.fromJson(data['user']);
    return _currentUser!;
  }

  Future<User> signup({
    required String fullName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirm,
  }) async {
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    final response = await _dio.post(ApiConstants.register, data: {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'password': password,
      'password_confirm': passwordConfirm,
    });
    final data = response.data;
    final tokens = data['tokens'];
    await _saveTokens(tokens['access'], tokens['refresh']);
    _currentUser = User.fromJson(data['user']);
    return _currentUser!;
  }

  Future<void> requestOtp(String email) async {
    await _dio.post(ApiConstants.otpRequest, data: {'email': email});
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    await _dio.post(ApiConstants.otpVerify, data: {'email': email, 'otp': otp});
  }

  Future<void> resetPassword(String email) async {
    await _dio.post(ApiConstants.passwordReset, data: {'email': email});
  }

  Future<void> confirmResetPassword({
    required String token,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    await _dio.post('${ApiConstants.passwordReset}confirm/', data: {
      'token': token,
      'new_password': newPassword,
      'new_password_confirm': newPasswordConfirm,
    });
  }

  Future<User> getProfile() async {
    final response = await _dio.get(ApiConstants.profile);
    _currentUser = User.fromJson(response.data);
    return _currentUser!;
  }

  Future<User> updateProfile({String? firstName, String? lastName, String? phone}) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phone != null) data['phone'] = phone;
    final response = await _dio.put(ApiConstants.profile, data: data);
    _currentUser = User.fromJson(response.data);
    return _currentUser!;
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      await _dio.post(ApiConstants.logout, data: {'refresh': refreshToken});
    } catch (_) {}
    _dio.clearTokens();
    _currentUser = null;
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> _saveTokens(String accessToken, String? refreshToken) async {
    _dio.setTokens(accessToken: accessToken, refreshToken: refreshToken);
    await _storage.write(key: 'access_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }
}
