import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_calc_rx_app/vm/calc_model.dart';

class Home extends StatelessWidget {
  Home({super.key}); //정의 property
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  //계산값 정의 안함 입력부분만 정의

  final calc = Get.find<CalcModel>(); //<<<<<<<<<<매우중요
  //다른 방법도 있음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('간단한 계산기')),
      body: GetBuilder<CalcModel>(
        //모델을 통해서 만듦-클래스
        builder: (controller) {
          //관리는 인스턴스 컨트롤러
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildInputTextField(
                    '첫번째 숫자를 입력하세요.',
                    num1Controller,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildInputTextField(
                    '두번째 숫자를 입력하세요.',
                    num2Controller,
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => calcAction(),
                      // context,
                      //provider context
                      child: Text('계산하기'),
                    ),
                    SizedBox(width: 28.0),
                    ElevatedButton(
                      onPressed: () => removeAction(),
                      //context,
                      //provider context
                      child: Text('지우기'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '덧셈결과',
                    calc.addResult,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '뺄셈결과',
                    calc.subResult,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '곱셈결과',
                    calc.mulResult,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '나눗셈결과',
                    calc.divResult,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  } //build

  //widgets
  Widget buildInputTextField(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }

  Widget buildResultTextField(
    String label,
    //TextEditingController controller,
    Rx rxValue,
  ) {
    return Obx(
      //<<<<<<<<<<<<<<<<<<<<<<<<execute
      //관찰자oobs계산value 정의obs//여기중요
      () => TextField(
        controller: TextEditingController(
          text: rxValue.value.toString(),
        ),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        readOnly: true,
      ),
    );
  }

  //functions
  //void calcAction(BuildContext context) {
  void calcAction() {
    //final calc = Get.find<CalcModel>();
    final num1Text = num1Controller.text.trim();
    final num2Text = num2Controller.text.trim();

    if (num1Text.isEmpty || num2Text.isEmpty) {
      //errorSnackBar();
      return; //중요 공부 필요
    }
    calc.num1.value = int.tryParse(num1Text) ?? 0;
    calc.num2.value = int.tryParse(num2Text) ?? 0;

    calc.calculate();
  }

  void removeAction() {
    //final calc = Get.find<CalcModel>();
    num1Controller.clear();
    num2Controller.clear();
    //Get.find<CalcModel>().clear();
    calc.clear();
  } //클리어 후 줘야함

  void errorSnackBar() {
    //
    Get.snackbar(
      "title",
      "message",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  //get snackbar변경
} //class stateful정의
