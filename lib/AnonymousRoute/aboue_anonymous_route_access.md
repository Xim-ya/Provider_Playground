## Provider Access - Anonymous route access
- 라우트된 위젯에서 Provider context에 접근해야되는 상황일 때는 `ChangeNotifier.value` 를 적용하면 됨.
- 아래는 라우트 이름이 없는 `anonymous route`를 예시로 함.


## 코드

### ViewModel
```dart
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

### View
#### RouteScreen

```dart
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
```

#### RoutedScreen
```dart
class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routed Counter Screen'),
      ),
      body: Center(
        child: Text('${context.watch<CounterViewModel>().count}'),
      ),
    );
  }
}
```



## 기타
- `MaterialPageRoute`을 이용해서 라우팅할 때 주의해야될 점이 있다.
```dart
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
```
-  위 코드 처럼 MaterialPageRoute을 할 때 builder의 `context`를 은닉하지 않으면 `ProviderNotFoundException`오류가 발생한다.
- 그 이유는 Provider context, 즉 Navigator.push의 `context`를 전달받아야 하지, `MaterailPageRoute` context에는 Provider 컨트롤러가 없기 때문이다.
