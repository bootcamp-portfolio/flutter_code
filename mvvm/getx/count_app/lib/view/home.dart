//home.dart

import 'package:count_app/vm/count.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GetX State')),
      body: GetBuilder<Counter>(
        //<<<<<<<getbuilder instance
        builder: (controller) {
          //변수이름 클래스 인스턴스//가져옴
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "현재 ${controller.totalCount}번 클릭했습니다.",
                ),
                Text(
                  "현재 카운트의 결과값은 ${controller.count} 입니다.",
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Get.find<Counter>().increment(); //실행 생성자
              Get.find<Counter>().clickCount();
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              Get.find<Counter>().decrement();
              Get.find<Counter>().clickCount();
            },
            backgroundColor: Colors.red,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
