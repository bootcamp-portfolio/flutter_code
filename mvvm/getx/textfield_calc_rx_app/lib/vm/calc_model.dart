import 'package:get/state_manager.dart';

class CalcModel extends GetxController {
  //provider change//선언시 옵져버//모델이 겟빌더한테 알려줌
  //반응형 클라스로 만든 정수 실수
  RxInt num1 = 0.obs; //observer
  RxInt num2 = 0.obs;
  RxInt addResult = 0.obs;
  RxInt subResult = 0.obs;
  RxInt mulResult = 0.obs;
  RxDouble divResult = 0.0.obs;

  //화면에 보임 프라퍼티 정의 데이터 밸류
  //property->반응형이기때문 옵저버선언 계산밸류
  void calculate() {
    addResult.value = num1.value + num2.value;
    subResult.value = num1.value - num2.value;
    mulResult.value = num1.value * num2.value;
    divResult.value = num2.value != 0
        ? num1.value / num2.value
        : 0.0;
  }

  void clear() {
    num1.value = 0;
    num2.value = 0;
    addResult.value = 0;
    subResult.value = 0;
    mulResult.value = 0;
    divResult.value = 0.0;
  }
} //계산은 계산만 클리어는 클리어만
