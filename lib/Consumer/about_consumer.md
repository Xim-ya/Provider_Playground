## Consumer
- Consumer를 사용하면 Provider.of<T> 나 Provider extension을 사용하지 않고 컨트롤러 인스턴스에 접글할 수 있음
- 새로운 위젯에 delegate builder 패턴으로 컨트롤러 인스턴스 접근함
- Consumer를 widget `rebuild 범위`를 줄여주기 때문에 앱 성능을 향상 시킬 수 있음.

### 원형

```dart 
Consumer
(
Key? key,
required Widget builder(BuildContext context, T
value
,
Widget
?
child
)
,
)
```

### 코드

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
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
        'Anohter Counter View ==> ${context
            .watch<CounterViewModel>()
            .count}');
  }
}
```

## 기타

- Consumer `Provider.of` 나 `Provider extension` 메소드처럼 컨트롤러 인스턴스에서 접근할 수 있다는 점에서 동일한 기능을 수행하지만 위젯의 `리빌드 범위`를 줄인다는 이점이 있음.
- 예를들어 위 코드에서 ConsumerScreen의 build 메소드 상단에는 `print("COUNTER SCREEN REBUILD");` 출력이 문이 존재한다.
  - Consumer을 사용하지 않는다면 컨트럴러 인스턴스가 업데이트 될 때 마다 업데이트 될 것이다.
  - 하지만 Consumer을 적용한다면 리빌드 범위를 줄이기 때문에 해당 출력이 나오지 않는다.
