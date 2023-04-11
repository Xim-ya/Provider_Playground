## Selector
- `Consumer` 위젯과 굉장히 유사하지만 세세한 컨트롤을 할 수 있는 위젯
-  사용되는 컨트롤러에 여러 업데이트가 되는 인스턴스가 많다면 우용한 접근 방법
  - 특정 인스턴스만 listen하고 리빌드를 하기 때문
- 하지만 코드양이 많이 지기 때문에 `context.select<T>()`를 쓰는 것도 고려해볼 필요가 있음


### 원형
```dart 
Selector({
  Key? key,
  required ValueWidgetBuilder<S> builder,
  required S selector(BuildContext, A),
})
```


### 코드

####  ViewModel
```dart
import 'package:flutter/material.dart';

class CounterViewModel extends ChangeNotifier {
  int count = 0;

  void increase() {
    count++;
    notifyListeners();
    print("counter increased ==> $count");
  }

  Future<void> asyncIncrease() async {
    await Future.delayed(const Duration(seconds: 2));
    count = count + 1;
    notifyListeners();
  }
}
```

#### View
```dart 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'counter_screen.dart';

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
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineLarge,
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
        'Anohter Counter View ==> ${context
            .read<CounterViewModel>()
            .count}');
  }
}
```