import 'User.dart'; // User 모델 임포트

class UserSession {
  static bool _isLoggedIn = false;
  static User? _currentUser;

  static bool get isLoggedIn => _isLoggedIn;
  static User? get currentUser => _currentUser;

  static void login(User user) {
    _isLoggedIn = true;
    _currentUser = user;
  }

  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }
}
