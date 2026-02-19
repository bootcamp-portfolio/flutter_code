import 'package:count2_app/vm/counter.dart';
import 'package:count2_app/vm/total_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = context
        .watch<Counter>()
        .count; //변수값 카운터 체크(감시observer) 후 화면 바꿈
    final totalCounter = context
        .watch<TotalCounter>()
        .count; //함수가 아니라 변수
    return Scaffold(
      appBar: AppBar(title: Text('Provider State')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //초기값
            Text('현재 $totalCounter번 클릭했습니다.'),
            Text('현재 카운터의 결과값은 $counter 입니다.'),
            //counter 가 가지고 있음
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<Counter>().increment();
              context.read<TotalCounter>().clickCount();
              //counter에 있는 increment? 실행read
              //상태관리 class가 함
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<Counter>().decrement();
              context.read<TotalCounter>().clickCount();
            },
            //counter에 있는 increment? 실행read
            //상태관리 class가 함
            backgroundColor: Colors.red,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  } //홈클릭 카운터에게 신호보냄 read->notify->watch정의 되어있어야함
} //홈이 카운터 다트의 int count property관찰

//시작은 count 함수read watch
//counter메모리 바뀌지 않음?
//delegate와 비슷 instance만들지 않음
//class instance만들지 않음
