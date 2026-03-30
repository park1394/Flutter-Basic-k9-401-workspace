import 'dart:async';

// Stream을 반환하는 함수는 async*로 선언합니다.
// async*로 :비동기 제너레이터 함수
// Stream<String> 객체를 반환하는 목적.
// 함수가 호출 즉시, 모든 코드를 실행하는게 아니라,
// listen() 을 통해 "구독"이 시작될 때, 실행이 된다.
// yield : 데이터를 방출.
// yield 키워드를 만날 때 마다, 해당 값을 스트림의 "파이프" 밖으로 내보내기.
// yield 이후에도 함수는 계속 실행이되고, 다음 yield 를 만나면 그 때 또 내보내기함.

Stream<String> calculate(int number) async* {
  for (int i = 0; i < 5; i++) {
    // StreamController의 add()처럼 yield 키워드를 이용해서 값 반환
    yield 'i = $i';
    await Future.delayed(Duration(seconds: 1));
  }
}

void playStream() {
  // StreamController와 마찬가지로 listen() 함수로 콜백 함수 입력
  calculate(1).listen((val) {
    print(val);
  });
}

void main() {
  playStream();
}