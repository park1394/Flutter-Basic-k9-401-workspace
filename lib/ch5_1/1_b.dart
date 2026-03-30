import '1_a.dart';

Parent parent = Parent(); // ✅ 인스턴스화 가능

base class Child1 extends Parent {}   // ✅ 가능
// class Child2 extends Parent {}       // ❌ 에러: base/sealed/final 필요
// class Child3 implements Parent {}    // ❌ 에러: implements 불가