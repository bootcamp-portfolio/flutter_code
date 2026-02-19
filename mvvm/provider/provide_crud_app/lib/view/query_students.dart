import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../vm/student_provider.dart';
import 'insert_students.dart';
import 'update_students.dart';
import 'delete_students.dart';

class QueryStudents extends StatelessWidget {
  const QueryStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final studentModel = context.watch<StudentModel>();
    final students = studentModel.students;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider CRUD for Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertStudents(),
              ),
            ),
          ),
        ],
      ),
      body: studentModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text('학생 정보가 없습니다'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final s = students[index];
                return ListTile(
                  title: Text('${s.name} (${s.code})'),
                  subtitle: Text('${s.dept} | ${s.phone}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateStudents(
                              code: s.code,
                              name: s.name,
                              dept: s.dept,
                              phone: s.phone,
                              address: s.address,
                            ),
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DeleteStudents(code: s.code),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
