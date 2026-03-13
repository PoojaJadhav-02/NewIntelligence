import 'package:get_storage/get_storage.dart';

class TokenStore {

  static final GetStorage _storage = GetStorage();

  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _loginKey = 'isLogin';

  /// Save User
  static Future<void> saveUser({
    required String email,
    required String password,
  }) async {
    await _storage.write(_emailKey, email);
    await _storage.write(_passwordKey, password);
    await _storage.write(_loginKey, true);
  }

  /// Get Email
  static String? getEmail() => _storage.read<String>(_emailKey);

  /// Check Login
  static bool isLoggedIn() => _storage.read(_loginKey) ?? false;

  /// Logout
  static Future<void> clearToken() async {
    await _storage.remove(_emailKey);
    await _storage.remove(_passwordKey);
    await _storage.write(_loginKey, false);
  }
}