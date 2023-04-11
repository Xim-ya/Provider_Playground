import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_playground/AnonymousRoute/counter_view_model.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routed Counter Screen'),
      ),
      body: Center(
        child: Text('${context.watch<CounterViewModel>().count}'),
      ),
    );
  }
}
