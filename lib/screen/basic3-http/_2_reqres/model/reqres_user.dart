// _2_reqres.in /api/users 응답의 단일 사용자 모델
class ReqresUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar; // 아바타 이미지 URL

  ReqresUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory ReqresUser.fromJson(Map<String, dynamic> json) {
    return ReqresUser(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatar: json['avatar'] as String,
    );
  }

  // 전체 이름 반환 헬퍼
  String get fullName => '$firstName $lastName';
}