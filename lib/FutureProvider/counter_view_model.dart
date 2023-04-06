import 'package:flutter/material.dart';

class CounterViewModel {

  Future<int> returnIncreasedValue() async {
    await Future.delayed(const Duration(seconds: 2));
    print("ACTIAVATED");
    return 1;
  }


  Future<int> returnIncreasedValue2() async {
    await Future.delayed(const Duration(seconds: 2));
    print("ACTIAVATED2");
    return 2;
  }
}
