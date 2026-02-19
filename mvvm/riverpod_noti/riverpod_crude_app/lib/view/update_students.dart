import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crude_app/model/student.dart';
import 'package:riverpod_crude_app/vm/student_provider.dart';

class UpdateStudents extends ConsumerStatefulWidget {
  final String code;
  final String name;
  final String dept;
  final String phone;
  final String address;

  UpdateStudents({
    super.key,
    required this.code,
    required this.name,
    required this.dept,
    required this.phone,
    required this.address,
  });

  @override
  ConsumerState<UpdateStudents> createState() =>
      _UpdateStudents();
}

class _UpdateStudents
    extends ConsumerState<UpdateStudents> {
  late final TextEditingController codeController;
  late final TextEditingController nameController;
  late final TextEditingController deptController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    nameController = TextEditingController();
    deptController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    codeController.text = widget.code;
    nameController.text = widget.name;
    deptController.text = widget.dept;
    phoneController.text = widget.phone;
    addressController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.read(
      studentNotifierProvider.notifier,
    );

    // codeController.text = code;
    // nameController.text = name;
    // deptController.text = dept;
    // phoneController.text = phone;
    // addressController.text = address;

    return Scaffold(
      appBar: AppBar(title: Text("Update Student")),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final student = Student(
                  code: codeController.text,
                  name: nameController.text,
                  dept: deptController.text,
                  phone: phoneController.text,
                  address: addressController.text,
                );
                final result = await studentState
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
