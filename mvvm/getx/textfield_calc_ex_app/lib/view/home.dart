import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_calc_ex_app/vm/calc_model.dart';

class Home extends StatelessWidget {
  Home({super.key}); //정의 property
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  final addController = TextEditingController();
  final subController = TextEditingController();
  final mulController = TextEditingController();
  final divController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('간단한 계산기')),
      body: GetBuilder<CalcModel>(
        //모델을 통해서 만듦-클래스
        builder: (controller) {
          //관리는 인스턴스 컨트롤러
          // addController.text = controller.addResult
          //     .toString(); //property1개 또는 전체
          // subController.text = controller.subResult
          //     .toString(); //property1개 또는 전체
          // mulController.text = controller.mulResult
          //     .toString(); //property1개 또는 전체
          // divController.text = controller.divResult
          //     .toStringAsFixed(3); //property1개 또는 전체
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
                    addController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '뺄셈결과',
                    subController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '곱셈결과',
                    mulController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: buildResultTextField(
                    '나눗셈결과',
                    divController,
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
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
    );
  }

  //functions
  //void calcAction(BuildContext context) {
  void calcAction() {
    final calc = Get.find<CalcModel>();
    final num1Text = num1Controller.text.trim();
    final num2Text = num2Controller.text.trim();

    if (num1Text.isEmpty || num2Text.isEmpty) {
      //errorSnackBar();
      return; //중요 공부 필요
    }
    final num1 = int.tryParse(num1Text) ?? 0;
    final num2 = int.tryParse(num2Text) ?? 0;

    calc.calculate(num1, num2);
    addController.text = calc.addResult.toString();
    subController.text = calc.subResult.toString();
    mulController.text = calc.mulResult.toString();
    divController.text = calc.divResult.toStringAsFixed(3);
    //Get.find<CalcModel>().calculate(num1, num2);
  }

  void removeAction() {
    final calc = Get.find<CalcModel>();
    num1Controller.clear();
    num2Controller.clear();
    //Get.find<CalcModel>().clear();
    calc.clear();

    addController.text = calc.addResult.toString();
    subController.text = calc.subResult.toString();
    mulController.text = calc.mulResult.toString();
    divController.text = calc.divResult.toStringAsFixed(3);
  } //클리어 후 줘야함

  // void errorSnackBar(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('숫자를 입력하세요.'),
  //       duration: Duration(seconds: 1),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }
  //get snackbar변경
} //class stateful정의
