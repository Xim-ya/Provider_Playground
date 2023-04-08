import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class CounterScreen2 extends StatelessWidget {
  const CounterScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("CounterScreen 2 build area rebuilded");
    return ChangeNotifierProvider(
      create: (_) => CounterViewModel(),
      child: Consumer(
        builder: (BuildContext context, CounterViewModel vm, Widget? child ) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("About ProviderFoundException"),
            ),
            body: Center(
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    const Text('Understanding ProviderFoundException'),
                    const SizedBox(height: 10),
                    Text(
                      vm.count.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                    // const CounterView(),
                    // const CounterView(),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final vm = context.read<CounterViewModel>();
                vm.increase();
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Nested Counter View ==> ${context.read<int>()}');
  }
}