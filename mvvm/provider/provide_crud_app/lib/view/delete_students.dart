import 'package:flutter/material.dart';
import 'package:provide_crud_app/vm/student_provider.dart';
import 'package:provider/provider.dart';

class DeleteStudents extends StatelessWidget {
  final String code;
  DeleteStudents({super.key, required this.code});
  final codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeController.text = code;
    final studentModel = context.read<StudentModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Delete Student")),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await studentModel
                    .deleteStudent(codeController.text);
                if (result == 'OK') {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  Navigator.of(context).pop();
                  _snackBar(
                    context,
                    '학생 정보가 삭제 되었습니다.',
                    Colors.blue,
                  );
                } else {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  _snackBar(
                    context,
                    '오류가 발생했습니다.',
                    Colors.red,
                  );
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
  void _snackBar(
    BuildContext context,
    String str,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str),
        duration: Duration(seconds: 1),
        backgroundColor: color,
      ),
    );
  }
} // class
