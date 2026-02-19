import 'package:count2_app/view/home.dart';
import 'package:count2_app/vm/counter.dart';
import 'package:count2_app/vm/total_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    //함수 등록
    MultiProvider(
      providers: //너한테 도움줄 아이 알려줌//2개
      [
        ChangeNotifierProvider(
          create: (context) => Counter(),
        ), //첫번째 함수 클래스 정의 주입 *injection* 주사기
        ChangeNotifierProvider(
          create: (context) => TotalCounter(),
        ), //첫번째 함수 클래스 정의 주입 *injection* 주사기
      ], //하나만child
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
      home: const Home(),
    );
  }
} //vm뭐쓸지 주입 메인에서
//메인은 처음에만 수정