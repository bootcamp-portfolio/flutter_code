import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_count_app/vm/counter_state.dart';

class CounterNotifier extends Notifier<CounterState> {
  //<<<<<<<<<<<<<<<<<<<<<<<2개바뀜

  @override
  CounterState build() => CounterState(); //<<<<<<<<<<<<<<<<

  void increment() {
    state = state.copywith(
      count: state.count + 1,
      totalClick: state.totalClick + 1,
    );
  }

  // void decrement() {
  //   state = state.copywith(
  //     count: state.count - 1,
  //     totalClick: state.totalClick - 1,
  //   );
  // }
}

//최신 Notifier provider 등록//state지움
final counterProvider =
    NotifierProvider<CounterNotifier, CounterState>(
      CounterNotifier.new,
    );
