import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_crud_app/model/student.dart';
import 'package:getx_crud_app/vm/student_handler.dart';

class UpdateStudents extends StatelessWidget {
  UpdateStudents({super.key});

  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final deptController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    codeController.text = args[0]; // s.code
    nameController.text = args[1]; // s.name
    deptController.text = args[2]; // s.dept
    phoneController.text = args[3]; // s.phone
    addressController.text = args[4]; // s.address

    final studentHandler = Get.find<StudentHandler>();

    return Scaffold(
      appBar: AppBar(title: const Text("Update Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              "학번",
              codeController,
              readOnly: true,
            ),
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
                final result = await studentHandler
                    .updateStudent(student);
                if (result == 'OK') {
                  if (!context.mounted)
                    return; // await 이후에는 context가 여전히 유효한지 확인
                  Navigator.of(context).pop();
                  _snackBar(
                    context,
                    '학생 정보가 수정 되었습니다.',
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
              child: const Text('수정'),
            ),
          ],
        ),
      ),
    );
  } // build

  // --- Widgets
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
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
