import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getx_crud_app/vm/student_handler.dart';
import 'insert_students.dart';
import 'update_students.dart';
import 'delete_students.dart';

class QueryStudents extends StatelessWidget {
  const QueryStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final studentHandler = Get.find<StudentHandler>();
    //studentHandler = fetchStudents();

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider CRUD for Students'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Get.to(InsertStudents()),
          ),
        ],
      ),
      body: Obx(
        () => studentHandler.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : studentHandler.students.isEmpty
            ? Center(child: Text('학생 정보가 없습니다'))
            : ListView.builder(
                itemCount: studentHandler.students.length,
                itemBuilder: (context, index) {
                  final s = studentHandler.students[index];
                  return ListTile(
                    title: Text('${s.name} (${s.code})'),
                    subtitle: Text(
                      '${s.dept} | ${s.phone}',
                    ),
                    onTap: () {
                      Get.to(
                        UpdateStudents(),
                        arguments: [
                          s.code,
                          s.name,
                          s.dept,
                          s.phone,
                          s.address,
                        ],
                      );
                    },
                    onLongPress: () {
                      Get.to(
                        DeleteStudents(),
                        arguments: [s.code],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
