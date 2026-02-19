import 'package:flutter/material.dart';

class Counter
    extends
        ChangeNotifier //vm부터
        {
  int count = 0;
  void increment() {
    //함수
    count++;
    notifyListeners(); //나를 와치하는 아이한테 정보//결과값 받음
    //read호출
  }

  void decrement() {
    count--;
    notifyListeners();
    //watch가 보고 화면에 뿌려줌->count보고 있음 홈의
  }
}
