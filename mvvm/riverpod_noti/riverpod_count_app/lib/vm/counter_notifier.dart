import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_count_app/vm/counter_state.dart';

//counternotifier 상태를 변경하는 로직을 담당하는 클래스-가장먼저
//statenotifier 상태를 직접 관리하고 변경하는 로직 담당하는 클래스
//counterstate 우리가 관리할 상태의 데이터 타입을 지정하는 클래스
class CounterNotifier extends StateNotifier<CounterState> {
  //상속받음 초기화 생성자//counternotifier가 처음 생성될때 초기 상태값 설정
  CounterNotifier()
    : super(CounterState()); //생성:내가 만든 데이터 전달

  //+버튼->count/totalclick증가
  void increment() {
    state = state.copywith(
      count: state.count + 1,
      totalClick: state.totalClick + 1,
    ); //counterstate//카피해서 값넣어줌
  }

  //-버튼
} //class->statenotifierprovier

//statenotifierprovier:클래스를 외부에서 사용가능하게 만들어주는 provider
//홈에서 와치하고 있음
final counterProvider =
    StateNotifierProvider<CounterNotifier, CounterState>(
      (ref) => CounterNotifier(),
    );
