import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/student.dart';
import '../vm/student_provider.dart';

class InsertStudents extends StatelessWidget {
  InsertStudents({super.key});

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final deptController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentModel = context.read<StudentModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Insert Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("학번", codeController),
            _buildTextField("성명", nameController),
            _buildTextField("전공", deptController),
            _buildTextField("전화번호", phoneController),
            _buildTextField("주소", addressController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final student = Student(
                  code: codeController.text,
                  name: nameController.text,
                  dept: deptController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                );
                final result = await studentModel
                    .insertStudent(student);
                if (result == 'OK') {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  Navigator.of(context).pop();
                  _snackBar(
                    context,
                    '학생 정보가 등록 되었습니다.',
                    Colors.blue,
                  );
                } else {
                  if (!context.mounted) return;
                  _snackBar(
                    context,
                    '오류가 발생했습니다.',
                    Colors.red,
                  );
                }
              },
              child: const Text('입력'),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Widgets
  Widget _buildTextField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

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
