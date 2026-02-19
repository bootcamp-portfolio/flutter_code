//main.dart

import 'package:count_app/view/home.dart';
import 'package:count_app/vm/count.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(Counter()); // <<<<<<<<<<<<<<<<<
  runApp(const MyApp()); //컨트롤러 주입
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // <<<<<<<<<<<<<<<<
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const Home(),
    );
  }
}
