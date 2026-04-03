// lib/features/_2_reqres/screens/dummy_user_screen.dart
import 'package:flutter/material.dart';
import '../models/dummy_user.dart';
import '../services/dummy_user_service.dart';

class DummyUserScreen extends StatefulWidget {
  const DummyUserScreen({super.key});
  @override
  State<DummyUserScreen> createState() => _DummyUserScreenState();
}

class _DummyUserScreenState extends State<DummyUserScreen> {
  late Future<List<DummyUser>> _usersFuture;
  int _currentPage = 0; // skip = page * limit
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = DummyUserService.fetchUsers(
        limit: _limit,
        skip: _currentPage * _limit,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DummyJSON 사용자 목록'),
        actions: [
          // 이전 페이지
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () {
              setState(() => _currentPage--);
              _loadUsers();
            }
                : null,
          ),
          // 현재 페이지 표시
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '${_currentPage + 1} 페이지',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          // 다음 페이지
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() => _currentPage++);
              _loadUsers();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DummyUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          // 로딩 중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 오류
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('오류: ${snapshot.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadUsers,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          // 빈 데이터
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('사용자가 없습니다.'));
          }

          final users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                // 아바타 이미지
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(user.image),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey.shade200,
                ),
                // 전체 이름
                title: Text(
                  user.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // 이메일
                subtitle: Text(
                  user.email,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                // ID 밹지
                trailing: Chip(
                  label: Text('#${user.id}'),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: const TextStyle(fontSize: 11),
                ),
              );
            },
          );
        },
      ),
    );
  }
}