class UserQna {
  final String consultType;
  final String contentType;
  final String title;
  final String content;
  final String name;
  final String phone;
  final String email;
  final DateTime createdAt;

  UserQna({
    required this.consultType,
    required this.contentType,
    required this.title,
    required this.content,
    required this.name,
    required this.phone,
    required this.email,
    required this.createdAt,
  });

  // JSON에서 객체로 변환
  factory UserQna.fromJson(Map<String, dynamic> json) {
    return UserQna(
      consultType: json['consultType'],
      contentType: json['contentType'],
      title: json['title'],
      content: json['content'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
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
      'createdAt': createdAt.toIso8601String(),
    };
  }
}