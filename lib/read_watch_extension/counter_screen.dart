import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class ProviderWrapper2 extends StatelessWidget {
  const ProviderWrapper2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CounterViewModel(), child: const CounterScreen());
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Counter Screen build area Rebuilds");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Using Change Notifier"),
      ),
      body: Center(
        child: FittedBox(
          child: Column(
            children: <Widget>[
              const Text('Rebuild UI by ChangeNotifier / Provider.of approach'),
              const SizedBox(height: 10),
              Text(
                context.watch<CounterViewModel>().count.toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const CounterView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final vm = Provider.of<CounterViewModel>(context, listen: false);
          final vm = context.read<CounterViewModel>();
          vm.increase();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        'Anohter Counter View ==> ${context.read<CounterViewModel>().count}');
  }
}
