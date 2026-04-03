// lib/features/_2_reqres/models/dummy_user.dart
class DummyUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image; // 아바타 이미지 URL

  DummyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
  });

  factory DummyUser.fromJson(Map<String, dynamic> json) {
    return DummyUser(
      id:        json['id'] as int,
      firstName: json['firstName'] as String,
      lastName:  json['lastName'] as String,
      email:     json['email'] as String,
      image:     json['image'] as String,
    );
  }

  String get fullName => '$firstName $lastName';
}