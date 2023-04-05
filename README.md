# Provider PlayGround

간단한 예제로를 기반으로 Provide 패캐지를 학습니다.

## Let's Get Started
## 상태관리 라이브러리가 뭔가?
- 상태관리가 뭐고 Provider에서 제공하는 Provider 상태관리 기능이 무엇이 있는가?
- provider을 상태관리를 도와주는 라이브러리를 제공하지만 특정 상태관리 라이브러리 특정 방법을 강제하지는 않는다.
- 인스턴스를 쉽게 접근할 수 있고 UI를 업데이트 해주는 역할



## Provider를 이용해 UI를 업데이트
- 간단한 Counter 앱을 만들면서 알아봄.
- MVVVM 패턴을 준수


### Provider.of

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

### read, watch extensionMethod


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
