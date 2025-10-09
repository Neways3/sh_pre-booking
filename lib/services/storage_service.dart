import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';

class StorageService {
  static final _box = GetStorage();

  static const String _userKey = 'user';
  static const String _tokenKey = 'token';
  static const String _isLoggedInKey = 'is_logged_in';

  static void saveUser(User user) {
    _box.write(_userKey, user.toJson());
    _box.write(_isLoggedInKey, true);
  }

  static User? getUser() {
    final userData = _box.read(_userKey);
    if (userData != null && isLoggedIn()) {
      return User.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  static void saveToken(String token) {
    _box.write(_tokenKey, token);
  }

  static String? getToken() {
    return _box.read(_tokenKey);
  }

  static bool isLoggedIn() {
    return _box.read(_isLoggedInKey) ?? false;
  }

  static void setLoggedIn(bool status) {
    _box.write(_isLoggedInKey, status);
  }

  static void logout() {
    _box.remove(_userKey);
    _box.remove(_tokenKey);
    _box.write(_isLoggedInKey, false);
  }

  static void clearAll() {
    _box.erase();
  }
}
