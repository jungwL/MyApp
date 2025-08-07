// User 모델 클래스
class User {
  final String userId;
  final String password;
  final String userName;
  final int userPoint;
  final String phoneNumber;// 연락처 추가됨

  User({
    required this.userId,
    required this.password,
    required this.userName,
    required this.userPoint,
    required this.phoneNumber
  });

  //JSON 형식의 데이터를 ==> User 객체로 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      password: json['password'],
      userName: json['userName'],
      userPoint: json['userPoint'],
      phoneNumber: json['phoneNumber']
    );
  }
}
