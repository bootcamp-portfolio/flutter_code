import 'package:flutter_riverpod/legacy.dart';
import 'package:textfield_calc_ex_app/vm/calc_state.dart';

class CalcNotifier extends StateNotifier<CalcState> {
  CalcNotifier() : super(CalcState());

  //state정의
  void caclulate(int n1, int n2) {
    state = state.copywith(
      num1: n1,
      num2: n2,
      addResult: n1 + n2,
      subResult: n1 - n2,
      mulResult: n1 * n2,
      divResult: n2 != 0 ? n1 / n2 : 0.0,
    );
  }

  void clear() {
    state = CalcState();
  }
} //calcNotifier

final calcProvider =
    StateNotifierProvider<CalcNotifier, CalcState>(
      (ref) => CalcNotifier(),
    );
