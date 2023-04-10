## How to avoid ProviderNotFoundException

```dart
 class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CounterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Using Consumer"),
        ),
        body: Center(
          child: FittedBox(
            child: Column(
              children: <Widget>[
                const Text('Rebuild UI by Consumer'),
                const SizedBox(height: 10),
                Text(
                  context.watch<CounterViewModel>().toString(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge,
                ),
                const CounterView(),
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
      ),
    );
  }
}
 ```

- 위 코드를 실행하면 `ProviderNotFoundException` 오류가 발생함
- `context.watch<CounterViewModel>()` 에서 참조하고 있는 context가 `ChangeNotifier` 의 context가
  아니라 `Widget build(BuildContext context)`의 context 받아오기 때문에 오류가 날 수 밖에 없음.

### 해결방법
#### 1. Builder 위젯으로 감싸기

```dart
class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CounterViewModel(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Using Consumer"),
            ),
            body: Center(
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    const Text('Rebuild UI by Consumer'),
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
                    ),
                    const CounterView(),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final vm =
                Provider.of<CounterViewModel>(context, listen: false);
                vm.increase();
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
 ```

- Builder Widget으로 감싸 Provider context을 찾아갈 수 있도록 변경 


#### 2. ChangeNotifier builder 속성이 필요 위젯 리턴
```dart

class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CounterViewModel(),
      builder: (BuildContext context, Widget? widget) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Using Consumer"),
          ),
          body: Center(
            child: FittedBox(
              child: Column(
                children: <Widget>[
                  const Text('Rebuild UI by Consumer'),
                  const SizedBox(height: 10),
                  Text(
                    context.watch<CounterViewModel>().count.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const CounterView(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final vm =
              Provider.of<CounterViewModel>(context, listen: false);
              vm.increase();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
```

#### 위젯 리팩토링
```dart
class CounterScreen04 extends StatelessWidget {
  const CounterScreen04({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterViewModel>(
      create: (_) => CounterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Using Consumer"),
        ),
        body: const CounterWidget(),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              final vm = context.read<CounterViewModel>();
              vm.increase();
            },
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Column(
          children: [
            const Text('Understanding ProviderFoundException'),
            const SizedBox(height: 10),
            Text('${context.watch<CounterViewModel>().count}')
          ],
        ),
      ),
    );
  }
}
```


### 결론
- 위 3가지 모두 `Builder패턴`으로 기반으로 Provider context가 필요한 위젯에게 적합한 위젯 트리 컨텐스를 설정하는 형태라고 이해할 수 있음.
- `Provider context`가 어디에 위치하고 있고, 위젯트리에 필요한 context가 전달되고 있는지 확인하여, `ProviderNotFoundException` 오류를 예방해야됨