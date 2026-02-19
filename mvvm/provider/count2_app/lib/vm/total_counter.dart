import 'package:flutter/material.dart';

class TotalCounter
    extends
        ChangeNotifier //vm부터//vm +-&total
        {
  int count = 0;
  void clickCount() {
    count++;
    notifyListeners();
  }
}
