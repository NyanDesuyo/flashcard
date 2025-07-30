// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_api_service.dart';
import '../services/secure_storage_service.dart';

// Represents the authentication state
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthStatus> {
  final AuthApiService _authApiService;
  final SecureStorageService _secureStorageService;

  AuthNotifier(this._authApiService, this._secureStorageService) : super(AuthStatus.unknown) {
    _checkAuthStatus(); // Check on startup
  }

  Future<void> _checkAuthStatus() async {
    final token = await _secureStorageService.getJwt();
    if (token != null) {
      // Potentially validate token with API or check expiration
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<bool> login(String email, String password) async {
    final token = await _authApiService.login(email, password);
    if (token != null) {
      await _secureStorageService.saveJwt(token);
      state = AuthStatus.authenticated;
      return true;
    }
    state = AuthStatus.unauthenticated;
    return false;
  }

  Future<bool> register(String email, String password) async {
    final user = await _authApiService.register(email, password);
    // After successful registration, you might automatically log them in or redirect to login.
    // For simplicity, let's assume direct login after registration.
    if (user != null) {
      return await login(email, password); // Log in after successful registration
    }
    return false;
  }

  Future<void> logout() async {
    await _secureStorageService.deleteJwt();
    state = AuthStatus.unauthenticated;
  }
}

// Providers for Riverpod
final secureStorageServiceProvider = Provider((ref) => SecureStorageService());
final authApiServiceProvider = Provider((ref) => AuthApiService());
final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier(
    ref.read(authApiServiceProvider),
    ref.read(secureStorageServiceProvider),
  );
});