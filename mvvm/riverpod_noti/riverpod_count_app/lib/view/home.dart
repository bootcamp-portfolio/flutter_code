import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_count_app/vm/counter_notifier.dart';
import 'package:riverpod_count_app/vm/counter_state.dart';

class Home extends ConsumerWidget {
  //<<<<<<<<<<<
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //<<<<<<<<
    final counterState = ref.watch(counterProvider);
    //맨아래 만듦
    return Scaffold(
      appBar: AppBar(title: Text('State')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //초기값
            Text('현재 ${counterState.totalClick}}번 클릭했습니다.'),
            Text(
              '현재 카운터의 결과값은 ${counterState.totalClick} 입니다.',
            ),
            //counter 가 가지고 있음
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              ref
                  .read(counterProvider.notifier)
                  .increment(); //함수 클래스 연결 레퍼런스
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {},
            //counter에 있는 increment? 실행read
            //상태관리 class가 함
            backgroundColor: Colors.red,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  } //홈클릭 카운터에게 신호보냄 read->notify->watch정의 되어있어야함
}
