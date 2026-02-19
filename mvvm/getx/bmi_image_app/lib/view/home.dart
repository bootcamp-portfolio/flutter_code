import 'package:bmi_image_app/vm/bmi_calc.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final TextEditingController _heightController =
      TextEditingController();
  final TextEditingController _weightController =
      TextEditingController();
  final calc = Get.find<BmiCalc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI')),
      body: GetBuilder<BmiCalc>(
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    buildInputTextField(
                      '신장를 입력',
                      _heightController as Rx<dynamic>,
                      false,
                    ),
                    buildInputTextField(
                      '몸무게를 입력',
                      _weightController as Rx<dynamic>,
                      false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          calcActon(context);
                        },
                        child: Text('계산'),
                      ),
                    ),
                    Obx(
                      () => Text(
                        calc.result.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Image.asset(
                        calc.bmiImage.value,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  } // build

  // === Widgets ===
  Widget buildInputTextField(
    String label,
    Rx rxValue,
    bool readOnly,
  ) {
    return Obx(
      () => TextField(
        controller: TextEditingController(
          text: rxValue.value.toString(),
        ),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  } // buildInputTextField

  // === Functions ===

  void calcActon(BuildContext context) {
    final heightText = _heightController.text.toString();
    final weightText = _weightController.text.toString();

    if (heightText.isEmpty || weightText.isEmpty) {
      errorSnackBar();
      return;
    }

    calc.height.value = double.tryParse(heightText) ?? 0.0;
    calc.weight.value = double.tryParse(weightText) ?? 0.0;

    calc.calculateBMI();
    successSnackBar();
  }

  void errorSnackBar() {
    Get.snackbar('title', 'message');
  }

  void successSnackBar() {
    Get.snackbar("title", "message");
  }
}
