### read, watch extensionMethod
- Provider extension 메소드를 사용한 데이터 감지고 데이터를 보여줄 수 있음.
- 단순히 컨트롤러 인스턴스에 접근하는거라면 read를 사용해도 무방하지만, 동적으로 업데이트되는 데이터 변화를 감지하기 위해서는 `watch` 메소드를 사용해야됨.
- 인스턴스가 변화할 떄 UI가 리빌드 되기 위해서 `notifyListeners` 메소드를 적용해주어야 함.


#### ViewModel
```dart
class CounterViewModel extends ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
    print("counter increased ==> $count");
  }
}
```

#### View
```dart
import 'package:flutter/material.dart';
import 'package:provider_playground/change_notifier/counter_screen.dart';
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
              const Text('Rebuild UI by ChangeNotifier / "read watch extensionMethod" approach'),
              const SizedBox(height: 10),
              Text(
                context
                    .watch<CounterViewModel>()
                    .count
                    .toString(),
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineLarge,
              )
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
  }
}
```
