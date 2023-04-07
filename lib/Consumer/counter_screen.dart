import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class ProviderWrapper6 extends StatelessWidget {
  const ProviderWrapper6({Key? key}) : super(key: key);

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
    print("COUNTER SCREEN REBUILD");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Using Consumer"),
      ),
      body: Center(
        child: FittedBox(
          child: Consumer<CounterViewModel>(
            child: const Text(
                'Rebuild UI by Consumer'),
            builder:
                (BuildContext context, CounterViewModel value, Widget? child) {
              return Column(
                children: <Widget>[
                  child!, // <-- child instance
                  const SizedBox(height: 10),
                  Text(
                    value.count.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const CounterView(),
                ],
              );
            },
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
        'Anohter Counter View ==> ${context.watch<CounterViewModel>().count}');
  }
}
