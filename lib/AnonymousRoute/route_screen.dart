import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_playground/AnonymousRoute/counter_view_model.dart';

import 'counter_screen.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Screen'),
      ),
      body: Center(
        child: FittedBox(
          child: ChangeNotifierProvider<CounterViewModel>(
            create: (context) => CounterViewModel(),
            builder: (context, _) {
              return Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return ChangeNotifierProvider.value(
                              value: context.read<CounterViewModel>(),
                              child: CounterScreen(),
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Route to Counter Screen'),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterViewModel>().increase();
                    },
                    child: const Text('Increase Count'),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
