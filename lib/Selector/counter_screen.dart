import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_view_model.dart';

class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("COUNTER SCREEN REBUILD");
    return ChangeNotifierProvider(
      create: (BuildContext context) => CounterViewModel(),
      builder: (BuildContext context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Using Consumer"),
          ),
          body: Center(
            child: FittedBox(
              child: Selector<CounterViewModel, int>(
                selector: (BuildContext context, CounterViewModel vm) =>
                    vm.count,
                builder: (_, int count, ___) {
                  return Column(
                    children: <Widget>[
                      const Text('Rebuild UI by Consumer'),
                      const SizedBox(height: 10),
                      Text(
                        count.toString(),
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
      },
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
