import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_calc_ex_app/vm/calc_model.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalcModel>();

    // //final String imageString;
    // final String bmiString;

    return Scaffold(
      appBar: AppBar(
        title: Text('bmi 계산기'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildInputTextField(
                '신장(cm)를 입력하세요.',
                heightController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildInputTextField(
                '몸무게(kg)를 입력하세요.',
                weightController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => calcAction(
                    context,
                  ), //provider context
                  child: Text('bmi계산'),
                ),
              ],
            ),
            Text(
              calc.bmiString,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 20),
            // calc.imageString.isNotEmpty
            //     ? Image.asset(calc.imageString, height: 200)
            //     : SizedBox(),
            //Image.asset('imageString', height: 200),
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

  //functions
  void calcAction(BuildContext context) {
    final h =
        int.tryParse(heightController.text.trim()) ?? 0;
    final w =
        int.tryParse(weightController.text.trim()) ?? 0;
    // 모델의 함수 실행 (read)
    context.read<CalcModel>().calc(h, w);
  }
} //class stateful정의
