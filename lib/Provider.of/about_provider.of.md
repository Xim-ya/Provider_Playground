### Provider.of
- Provider.of를 이용하게 쉽게 ChangeNotifier 인스턴스에 접근할 수 잇음
- 인스턴스가 변화할 떄 UI가 리빌드 되기 위해서 `notifyListeners` 메소드를 적용해주어야 함.
  - Getx의 `update` 메소드와 유사함.
- 만약 동적으로 인스터를 사용하는게 아니라면 listen 속성을 false로 설정해주면 됨. ex) Provider.of<T>(context , listen: false)
- 당연한 이야기겠지만 Provider 컨트롤러가 Wraper 되어야 함. ex) ChangeNotifier



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
import 'package:provider_playground/change_notifier/counter_view_model.dart';
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
              )
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
```