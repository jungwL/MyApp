// User.dart // User 모델 클래스
class User {
  final String userId;
  final String password;
  final String userName;
  final int userPoint;
  final String phoneNumber;
  final int pinNo;
  final String userAddress; // late final 제거, final로 통일

  User({
    required this.userId,
    required this.password,
    required this.userName,
    required this.userPoint,
    required this.phoneNumber,
    required this.pinNo,
    required this.userAddress
  });

  // [수정] null 값에 대비하여 더 안전한 코드로 변경
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? 'unknown_id', // null이면 'unknown_id' 사용
      password: json['password'] ?? '',
      userName: json['userName'] ?? '이름 없음',
      userPoint: json['userPoint'] ?? 0, // 숫자 타입은 0으로 기본값 설정
      phoneNumber: json['phoneNumber'] ?? '연락처 없음',
      pinNo: json['pinNo'] ?? 0,
      userAddress: json['userAddress'] ?? '주소 없음',
    );
  }
}