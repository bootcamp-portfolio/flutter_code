import 'package:flutter/material.dart';
import 'package:provide_crud_app/view/query_students.dart';
import 'package:provide_crud_app/vm/student_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              StudentModel()..fetchStudents(),
        ), //다른 방법도 있음
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const QueryStudents(),
    );
  }
}
