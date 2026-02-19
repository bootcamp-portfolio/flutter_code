import 'package:flutter/material.dart';

class CalcModel extends ChangeNotifier {
  double weight = 0;
  double height = 0;
  String bmiString = '';
  //String imageString = '';

  void calc(int heightInput, int weightInput) {
    if (heightInput <= 0 || weightInput <= 0) {
      bmiString = '키와 몸무게를 정확히 입력하세요.';
      notifyListeners();
      return;
    }
    height = heightInput.toDouble();
    weight = weightInput.toDouble();

    double bmi = weight / (height * height / 10000);
    String fixedBmi = bmi.toStringAsFixed(1);

    if (bmi < 18.5) {
      bmiString = '귀하의 BMI지수는 $fixedBmi이고 저체중입니다.';
      //  imageString = 'images/underweight.png';
    } else if (bmi < 23) {
      bmiString = '귀하의 BMI지수는 $fixedBmi이고 정상체중입니다.';
      // imageString = 'images/normal.png';
    } else if (bmi < 25) {
      bmiString = '귀하의 BMI지수는 $fixedBmi이고 과체중입니다.';
      //   imageString = 'images/risk.png';
    } else {
      bmiString = '귀하의 BMI지수는 $fixedBmi이고 비만입니다.';
      //  imageString = 'images/overweight.png';
    }

    void clear() {
      bmiString = '';
      //imageString = '';
      notifyListeners();
    }
  }
}
