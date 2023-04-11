import 'package:flutter/material.dart';

class CounterViewModel extends ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
    print("counter increased ==> $count");
  }

  Future<void> asyncIncrease() async {
    await Future.delayed(const Duration(seconds: 2));
    count = count + 1;
    notifyListeners();
  }
}
