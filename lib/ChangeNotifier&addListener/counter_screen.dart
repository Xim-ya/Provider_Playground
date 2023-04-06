import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_playground/ChangeNotifier&addListener/counter_view_model.dart';

class CounterScreen3 extends StatefulWidget {
  const CounterScreen3({Key? key}) : super(key: key);

  @override
  State<CounterScreen3> createState() => _CounterScreen3State();
}

class _CounterScreen3State extends State<CounterScreen3> {
  final vm = CounterViewModel();

  @override
  void initState() {
    super.initState();

    vm.addListener(() {
      print("Changed");
    });
  }

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
                vm.count.toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              // const CounterView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
