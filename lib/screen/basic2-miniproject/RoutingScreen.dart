import 'package:busanit_401_k9_flutter_project/screen/basic2-miniproject/TabBarScreen.dart';
import 'package:busanit_401_k9_flutter_project/screen/basic3-http/_3_news_api/screens/news_screen.dart';
import 'package:busanit_401_k9_flutter_project/screen/basic3-http/_4_public_data_1_earthquake/screens/PublicDataScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../basic3-http/_1_dummyJson/screens/dummy_user_screen.dart';
import '../basic3-http/_2_reqres/screen/reqres_screen.dart';
import 'AccordionNavScreen.dart';
import 'DetailsScreen.dart';
import 'LoginScreen2.dart';
import 'MainScreen.dart';
import 'SignupScreen.dart';
import 'SplashScreen.dart';
import 'ViewPagerScreen.dart';

class RoutingScreen extends StatelessWidget {
  const RoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/main':    (context) => const MainScreen(),
        '/signup':  (context) => const SignupScreen(),
        '/login':   (context) => const LoginScreen2(),
        '/details': (context) => const DetailsScreen(),
        // 탭 메뉴 화면 추가.
        '/tabMenuTest': (context) => const TabBarScreen(),
        '/viewPagerTest': (context) => const PageViewScreen(),
        '/drawerNaviTest': (context) => const AccordionNavScreen(),
        // API 서버 호출 테스트
        '/reqresTest': (context) => const ReqresScreen(),
        '/dummyTest': (context) => const DummyUserScreen(),
        '/newsTest': (context) => const NewsScreen(),
        '/publicDataTest': (context) => const PublicDataScreen(),

      },
    );
  }
}