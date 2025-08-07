import 'User.dart'; // User 모델 임포트

class UserSession {
  static bool _isLoggedIn = false; //로그인 상태값 저장
  static User? _currentUser; //로그인한 사용자 정보 저장 ? : null값 허용

  //getter
  static bool get isLoggedIn => _isLoggedIn;
  static User? get currentUser => _currentUser;

  //로그인 함수
  static void login(User user) {
    _isLoggedIn = true;
    _currentUser = user;
  }

  //로그 아웃함수
  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }
}
