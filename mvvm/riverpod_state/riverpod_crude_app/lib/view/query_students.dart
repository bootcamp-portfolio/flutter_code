import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_crude_app/view/delete_students.dart';
import 'package:riverpod_crude_app/view/update_students.dart';
import 'package:riverpod_crude_app/vm/student_provider.dart';
import 'insert_students.dart';

class QueryStudents extends ConsumerWidget {
  //<<<<<<<<<<<
  const QueryStudents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(StudentNotifierProvider);

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
      body: studentAsync.when(
        data: (students) {
          //<<<<<<<<<<<<<<<데이터를 스튜던츠로 바꿈
          return students.isEmpty
              ? const Center(child: Text('학생 정보가 없습니다'))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final s = students[index];
                    return ListTile(
                      title: Text('${s.name} (${s.code})'),
                      subtitle: Text(
                        '${s.dept} | ${s.phone}',
                      ),
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
                                DeleteStudents(
                                  code: s.code,
                                ),
                          ),
                        );
                      },
                    );
                  },
                );
        },
        error: (error, stackTrace) =>
            Center(child: Text('Error: $error')),
        loading: () =>
            Center(child: CircularProgressIndicator()),
      ),
    );
  }
} //async->try막음
