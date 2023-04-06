import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class ProviderWrapper4 extends StatelessWidget {
  const ProviderWrapper4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final vm = CounterViewModel();
            return vm.returnIncreasedValue();
          },
        ),
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final vm = CounterViewModel();
            return vm.returnIncreasedValue2();
          },
        ),
      ],
      child: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Future Provider"),
      ),
      body: Center(
        child: FittedBox(
          child: Column(
            children: <Widget>[
              const Text('You can use ethier provider.of or context extension'),
              const SizedBox(height: 10),
              Text(
                context.read<int>().toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              // const CounterView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
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
