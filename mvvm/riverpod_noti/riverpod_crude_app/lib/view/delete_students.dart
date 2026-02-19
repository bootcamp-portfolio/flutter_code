import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_crude_app/vm/student_provider.dart';

class DeleteStudents extends ConsumerStatefulWidget {
  final String code;
  DeleteStudents({super.key, required this.code});

  @override
  ConsumerState<DeleteStudents> createState() =>
      _DeleteStudents();
}

class _DeleteStudents
    extends ConsumerState<DeleteStudents> {
  late final TextEditingController codeController;
  @override
  initState() {
    super.initState();
    codeController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    codeController.text = widget.code;

    //stateless+ref->stateful

    final studentNotifier = ref.read(
      // studentNotifierProvider.notifier
      studentNotifierProvider.notifier,
    );

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
                final result = await studentNotifier
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
              child: Text('삭제'),
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
