import 'package:flutter_riverpod/legacy.dart';

//거대한 오래된
class TabNotifier extends StateNotifier<int> {
  //state=int
  TabNotifier() : super(0);

  void changeTab(int index) {
    state = index;
  }
} //currentindex순서

final TabNotifierProvider =
    StateNotifierProvider<TabNotifier, int>(
      (ref) => TabNotifier(),
    );
