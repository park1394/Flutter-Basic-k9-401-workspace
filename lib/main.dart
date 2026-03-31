import 'package:flutter/material.dart';

void main() {
  // 1. main 함수는 단순히 MyApp이라는 위젯을 실행하는 역할만 합니다.
  runApp(MyApp());
}

// 2. 화면의 구조를 정의하는 새로운 위젯 클래스를 만듭니다.
// (상태가 변하지 않는 StatelessWidget)
class MyApp extends StatelessWidget {

  // 3. 바로 이 build() 함수가 핫 리로드의 핵심입니다!
  // 코드를 수정하고 저장하면, 플러터는 main()이 아닌
  // 이 build() 함수만 다시 실행합니다.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center( // 가운데 배치하는 역할. 단일 위젯
          child: Text(
            // 이 글자를 수정해 보세요.
            '이제 핫 리로드가 완벽하게 작동합니다!',
            // 옵션, 텍스트 옵션, 1)크기 2) 굵기 3) 색상
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.blue
            ),
          ),
        ),
      ),
    );
  }
}