import 'package:flutter/material.dart';
import 'package:provider_playground/Provider.of/counter_view_model.dart';

import 'package:provider/provider.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({Key? key}) : super(key: key);

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
                Provider.of<CounterViewModel>(context).count.toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const CounterView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final vm = Provider.of<CounterViewModel>(context, listen: false);
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
