import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:textfield_calc_ex_app/vm/calc_notifier.dart';

class Home extends ConsumerWidget {
  //<<<<<<<<<<
  Home({super.key});
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  final addController = TextEditingController();
  final subController = TextEditingController();
  final mulController = TextEditingController();
  final divController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //<<<<<<<
    final CalcState = ref.watch(calcProvider);

    //초기값정의 결과를 텍스트로 갱신
    addController.text = CalcState.addResult
        .toString(); //property1개 또는 전체
    subController.text = CalcState.subResult
        .toString(); //property1개 또는 전체
    mulController.text = CalcState.mulResult
        .toString(); //property1개 또는 전체
    divController.text = CalcState.divResult
        .toStringAsFixed(3); //property1개 또는 전체

    return Scaffold(
      appBar: AppBar(title: Text('간단한 계산기')),
      body: Center(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    calcAction(context, ref);
                  }, //provider context
                  child: Text('계산하기'),
                ),
                SizedBox(width: 28.0),
                ElevatedButton(
                  onPressed: () {
                    removeAction(context, ref);
                  },
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
  void calcAction(BuildContext context, WidgetRef ref) {
    final num1Text = num1Controller.text.trim();
    final num2Text = num2Controller.text.trim();

    if (num1Text.isEmpty || num2Text.isEmpty) {
      errorSnackBar(context);
      return; //중요 공부 필요
    }
    final num1 = int.tryParse(num1Text) ?? 0;
    final num2 = int.tryParse(num2Text) ?? 0;
    //스페이스 0으로 간주

    ref.read(calcProvider.notifier).caclulate(num1, num2);
  }

  void removeAction(BuildContext context, WidgetRef ref) {
    num1Controller.clear();
    num2Controller.clear();
    ref.read(calcProvider.notifier).clear();
  }

  void errorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('숫자를 입력하세요.'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
  }
} //class stateful정의
