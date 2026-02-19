import 'package:flutter_riverpod/flutter_riverpod.dart';

//거대한 오래된
class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) {
    state = index;
  }
} //currentindex순서

final tabNotifierProvider =
    NotifierProvider<TabNotifier, int>(TabNotifier.new);
