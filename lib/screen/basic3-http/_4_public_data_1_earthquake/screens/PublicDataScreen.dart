import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/EarthquakeInfo.dart';
import '../services/EarthquakeApiService.dart';

class PublicDataScreen extends StatefulWidget {
  const PublicDataScreen({super.key});
  @override
  State<PublicDataScreen> createState() => _PublicDataScreenState();
}

class _PublicDataScreenState extends State<PublicDataScreen> {
  // Future: 비동기 작업의 미래 결과를 표현
  late Future<List<EarthquakeInfo>> _earthquakeFuture;

  @override
  void initState() {
    super.initState();
    _loadData(); // 화면 시작 시 데이터 로드
  }

  void _loadData() {
    setState(() {
      _earthquakeFuture = EarthquakeApiService.fetchEarthquakes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공공데이터 - 지진정보'),
        actions: [
          // 새로고침 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      // FutureBuilder: Future 상태에 따라 UI를 다르게 표시
      body: FutureBuilder<List<EarthquakeInfo>>(
        future: _earthquakeFuture,
        builder: (context, snapshot) {
          // 1. 로딩 중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. 에러 발생
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('오류: \${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('재시도'),
                  ),
                ],
              ),
            );
          }
          // 3. 데이터 없음
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('데이터가 없습니다.'));
          }
          // 4. 데이터 있음 -> 리스트 표시
          final earthquakes = snapshot.data!;
          return ListView.builder(
            itemCount: earthquakes.length,
            itemBuilder: (context, index) {
              final eq = earthquakes[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: eq.magnitude >= 3.0
                        ? Colors.red  // 규모 3.0 이상: 붉은색
                        : Colors.orange,
                    child: Text(
                      eq.magnitude.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ),
                  title: Text(eq.location),
                  subtitle: Text(eq.originTime),
                  trailing: Text('진원: \${eq.depth}km'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}