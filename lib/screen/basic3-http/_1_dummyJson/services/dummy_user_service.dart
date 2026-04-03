// lib/features/_2_reqres/services/dummy_user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dummy_user.dart';

class DummyUserService {
  // API 키 불필요!
  static const String _baseUrl = 'https://dummyjson.com/users';

  // limit: 가져올 수, skip: 건너뜀 수 (페이지네이션)
  static Future<List<DummyUser>> fetchUsers({
    int limit = 10,
    int skip = 0,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'limit': limit.toString(),
        'skip': skip.toString(),
      },
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      // 응답 구조: { users: [...], total: 208, skip: 0, limit: 10 }
      final List<dynamic> users = data['users'] as List<dynamic>;
      return users
          .map((u) => DummyUser.fromJson(u as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('사용자 로드 실패: ${response.statusCode}');
    }
  }
}