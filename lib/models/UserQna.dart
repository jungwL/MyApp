class UserQna {
  final String consultType;
  final String contentType;
  final String title;
  final String content;
  final String name;
  final String phone;
  final String email;
  final DateTime addTime;

  UserQna({
    required this.consultType,
    required this.contentType,
    required this.title,
    required this.content,
    required this.name,
    required this.phone,
    required this.email,
    required this.addTime,
  });

  // JSON에서 객체로 변환
  factory UserQna.fromJson(Map<String, dynamic> json) {
    return UserQna(
      consultType: json['consultType'] ?? '',
      contentType: json['contentType'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      addTime: json['addTime'] != null
          ? DateTime.parse(json['addTime'])
          : DateTime.now(),  // null일 경우 현재 시간으로 기본 설정
    );
  }


  // 객체를 JSON으로 변환 (요청 시 사용 가능)
  Map<String, dynamic> toJson() {
    return {
      'consultType': consultType,
      'contentType': contentType,
      'title': title,
      'content': content,
      'name': name,
      'phone': phone,
      'email': email,
      'addTime': addTime.toIso8601String(),
    };
  }
}