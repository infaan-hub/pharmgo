import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    await _authService.init();
    state = AuthState(
      isAuthenticated: _authService.isLoggedIn,
      user: _authService.currentUser,
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.login(email: email, password: password);
      state = AuthState(isAuthenticated: true, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirm,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signup(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      state = AuthState(isAuthenticated: true, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
