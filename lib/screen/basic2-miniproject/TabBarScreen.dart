import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}
// SingleTickerProviderStateMixin: 탭 전환 애니메이션을 위한 Ticker(심박수)를 제공합니다.
// 이 Mixin을 추가해야 TabController의 vsync에 'this'를 전달할 수 있습니다.
class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {

  // TabController: 탭의 상태(현재 인덱스 등)를 관리하고 탭 전환을 조절합니다.
  // late 키워드: initState에서 초기화될 것임을 명시합니다.
  late TabController _tabController;

  // 탭 화면구성을 위한 동적 데이터 목록 (아이콘, 라벨, 테마 색상)
  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.home, 'label': '홈', 'color': Colors.blue},
    {'icon': Icons.search, 'label': '검색', 'color': Colors.green},
    {'icon': Icons.favorite, 'label': '즐겨찾기', 'color': Colors.red},
    {'icon': Icons.person, 'label': '프로필', 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    // length: 총 탭의 개수
    // vsync: 애니메이션의 효율성을 위해 화면 주사율에 맞게 Ticker를 연결 (this = 현재 클래스)
    _tabController = TabController(length: _tabs.length, vsync: this);

    // 탭 변경 리스너(Listener) 등록: 사용자가 탭을 클릭하거나 슬라이드할 때 호출됨
    _tabController.addListener(() {
      // indexIsChanging: 탭 전환 애니메이션이 진행 중일 때는 중복 호출을 막기 위해 false일 때만 실행
      if (!_tabController.indexIsChanging) {
        // 현재 인덱스가 바뀌었음을 감지하고 UI를 다시 그려 AppBar 제목/색상을 업데이트함
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // 컨트롤러 해제: 사용이 끝난 컨트롤러는 메모리 누수 방지를 위해 반드시 dispose 호출
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 컨트롤러의 현재 index를 사용하여 제목을 동적으로 변경
        title: Text('현재: ${_tabs[_tabController.index]['label']}'),
        // 배경색도 현재 선택된 탭의 색상으로 부드럽게 변경됨
        backgroundColor: _tabs[_tabController.index]['color'] as Color,

        // bottom: AppBar 하단에 탭 바 위젯 배치
        bottom: TabBar(
          controller: _tabController,       // 상단 정의한 컨트롤러 연결
          indicatorColor: Colors.white,      // 탭 밑에 표시되는 줄(인디케이터) 색상
          indicatorWeight: 3.0,              // 인디케이터 두께
          labelColor: Colors.white,          // 선택된 탭의 아이콘/텍스트 색상
          unselectedLabelColor: Colors.white70, // 선택되지 않은 탭의 색상
          isScrollable: false,               // 탭 개수가 적으므로 전체 너비에 균등 배치
          tabs: _tabs.map((tab) {
            return Tab(
              icon: Icon(tab['icon'] as IconData),
              text: tab['label'] as String,
            );
          }).toList(),
        ),
      ),

      // TabBarView: 각 탭을 클릭했을 때 보여줄 실제 화면 콘텐츠 영역
      body: TabBarView(
        controller: _tabController, // AppBar의 TabBar와 같은 컨트롤러를 공유해야 함
        children: _tabs.map((tab) {
          return Container(
            // 배경색에 아주 투명한 농도를 주어 은은하게 배경 처리
            color: (tab['color'] as Color).withOpacity(0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 80,
                    color: tab['color'] as Color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${tab['label']} 화면',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: tab['color'] as Color,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),

      // bottomNavigationBar: 하단에 버튼을 두어 코드로 탭을 제어하는 예시
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _tabs.length,
                (index) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                // 현재 선택된 인덱스인 버튼만 컬러 표시, 나머지는 회색
                backgroundColor: _tabController.index == index
                    ? _tabs[index]['color'] as Color
                    : Colors.grey,
              ),
              onPressed: () {
                // animateTo(index): 특정 인덱스로 애니메이션과 함께 이동
                _tabController.animateTo(index);
              },
              child: Text('탭${index + 1}'),
            ),
          ),
        ),
      ),
    );
  }
}
