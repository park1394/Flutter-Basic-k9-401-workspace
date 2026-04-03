import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 네비게이션 메뉴 데이터 모델
class NavMenuItem {
  final String title;
  final IconData icon;
  final List<String> subItems; // 하위 메뉴 목록
  const NavMenuItem({
    required this.title,
    required this.icon,
    required this.subItems,
  });
}

class AccordionNavScreen extends StatefulWidget {
  const AccordionNavScreen({super.key});
  @override
  State<AccordionNavScreen> createState() => _AccordionNavScreenState();
}

class _AccordionNavScreenState extends State<AccordionNavScreen> {
  String _selectedMenu = '홈'; // 현재 선택된 메뉴

  // 네비게이션 메뉴 데이터
  final List<NavMenuItem> _menuItems = const [
    NavMenuItem(
      title: '상품',
      icon: Icons.shopping_bag,
      subItems: ['전체 상품', '신상품', '인기상품', '할인상품'],
    ),
    NavMenuItem(
      title: '커뮤니티',
      icon: Icons.people,
      subItems: ['공지사항', '이벤트', '후기', 'Q&A'],
    ),
    NavMenuItem(
      title: '고객센터',
      icon: Icons.support_agent,
      subItems: ['자주묻는질문', '문의하기', '반품/교환', '배송조회'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- 애플리케이션 헤더 ---
      appBar: AppBar(
        title: Text(_selectedMenu),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        // 드로우어를 여는 햄버거 당긴 아이콘
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: '네비게이션 메뉴',
          ),
        ),
        actions: [
          // 헤더 우측 드롭다운 메뉴
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() => _selectedMenu = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '로그인', child: Text('회원로그인')),
              const PopupMenuItem(value: '관심상품', child: Text('관심상품')),
              const PopupMenuItem(value: '설정', child: Text('설정')),
              const PopupMenuDivider(), // 구분선
              const PopupMenuItem(value: '로그아웃', child: Text('로그아웃')),
            ],
          ),
        ],
      ),

      // --- 사이드 드로우어 (아코디언 네비게이션) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // 상단 패딩 제거
          children: [
            // 드로우어 헤더
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '사용자님',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'user@example.com',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            // 홈 메뉴
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('홈'),
              onTap: () {
                setState(() => _selectedMenu = '홈');
                Navigator.pop(context); // 드로우어 닫기
              },
            ),
            // 아코디언 메뉴 목록
            // ... 의미 : 개별 요소로 분해하는 (spread연산자.)
            // _menuItems 3개가 펼쳐져서 ListTile 3개로 변환해줌.
            //  NavMenuItem(
            //       title: '상품',
            //       icon: Icons.shopping_bag,
            //       subItems: ['전체 상품', '신상품', '인기상품', '할인상품'],
            //     ),
            ..._menuItems.map((menuItem) {
              return ExpansionTile(
                leading: Icon(menuItem.icon), // 메뉴 아이콘
                title: Text(menuItem.title),  // 메뉴 제목
                // 하위 메뉴 아이템
                children: menuItem.subItems.map((subItem) {
                  return ListTile(
                    contentPadding:
                    const EdgeInsets.only(left: 56, right: 16),
                    title: Text(subItem),
                    onTap: () {
                      setState(() => _selectedMenu = subItem);
                      Navigator.pop(context); // 드로우어 닫기
                    },
                  );
                }).toList(),
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      // --- 메인 콘텐츠 ---
      body: Center(
        child: Text(
          '선택된 메뉴:\n$_selectedMenu',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}