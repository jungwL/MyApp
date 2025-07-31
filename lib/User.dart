// User 모델 클래스
class User {
  final String userId;
  final String password;
  final String userName; //  추가됨
  final int userPoint;
  final String phoneNumber;

  User({
    required this.userId,
    required this.password,
    required this.userName, //  생성자에 추가
    required this.userPoint,
    required this.phoneNumber
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      password: json['password'],
      userName: json['userName'], //  JSON 파싱에 추가
      userPoint: json['userPoint'],
      phoneNumber: json['phoneNumber']
    );
  }
}
