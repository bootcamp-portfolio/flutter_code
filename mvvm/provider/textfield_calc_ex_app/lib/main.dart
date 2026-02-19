import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_calc_ex_app/view/home.dart';
import 'package:textfield_calc_ex_app/vm/calc_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: //너한테 도움줄 아이 알려줌//2개
      [
        ChangeNotifierProvider(
          create: (context) => CalcModel(),
        ),
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
      home: Home(), //콘스트 지움
    );
  }
}
