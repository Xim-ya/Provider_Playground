import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterViewModel>(
      create: (_) => CounterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Using Consumer"),
        ),
        body: const CounterWidget(),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final vm = context.read<CounterViewModel>();
              vm.increase();
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Column(
          children: [
            const Text('Understanding ProviderFoundException'),
            const SizedBox(height: 10),
            Text('${context.watch<CounterViewModel>().count}')
          ],
        ),
      ),
    );
  }
}
