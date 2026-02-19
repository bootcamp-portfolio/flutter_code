import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_crud_app/vm/student_handler.dart';

class DeleteStudents extends StatelessWidget {
  DeleteStudents({super.key});

  final codeController = TextEditingController();
  //final String code;

  @override
  Widget build(BuildContext context) {
    //codeController.text = code;
    var args = Get.arguments;
    codeController.text = args[0];
    final studentHandler = Get.find<StudentHandler>();

    return Scaffold(
      appBar: AppBar(title: Text("Delete Student")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: '학번',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await studentHandler
                    .deleteStudent(codeController.text);
                if (result == 'OK') {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  Navigator.of(context).pop();
                  _snackBar(
                    '학생 정보가 삭제 되었습니다.',
                    Colors.blue,
                  );
                } else {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  _snackBar('오류가 발생했습니다.', Colors.red);
                }
              },
              child: const Text('삭제'),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Functions
  void _snackBar(String str, Color color) {
    Get.snackbar(
      '삭제',
      str,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} // class
