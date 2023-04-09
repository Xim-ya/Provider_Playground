## ProviderNotFountException
- Provider을 사용하면 흔하게 접할 수 있는 Exception
```md

Error: Could not find the correct Provider<CounterViewModel> above this ProviderWrapper2 Widget

This happens because you used a `BuildContext` that does not include the provider
of your choice. There are a few common scenarios:

- You added a new provider in your `main.dart` and performed a hot-reload.
  To fix, perform a hot-restart.

- The provider you are trying to read is in a different route.

  Providers are "scoped". So if you insert of provider inside a route, then
  other routes will not be able to access that provider.

- You used a `BuildContext` that is an ancestor of the provider you are trying to read.

  Make sure that ProviderWrapper2 is under your MultiProvider/Provider<CounterViewModel>.
  This usually happens when you are creating a provider and trying to read it immediately.

  For example, instead of:


  Widget build(BuildContext context) {
  return Provider<Example>(
  create: (_) => Example(),
  // Will throw a ProviderNotFoundError, because `context` is associated
  // to the widget that is the parent of `Provider<Example>`
  child: Text(context.watch<Example>().toString()),
 );
 }
  

  consider using `builder` like so:

  
  Widget build(BuildContext context) {
  return Provider<Example>(
    create: (_) => Example(),
    // we use `builder` to obtain a new `BuildContext` that has access to the provider
    builder: (context, child) {
    // No longer throws
  return Text(context.watch<Example>().toString()); 
  }
);
}
```
위 `ProviderNotFoundException` 의 경우에는 3가지 오류 타입에 대해서 log를 보여주고 있는데 마지막
`You used a `BuildContext` that is an ancestor of the provider you are trying to read.` 오류 형태에 대해 다루어 보려고함.


## 오류 코드 재현
```dart
Widget build(BuildContext context) {
  return Provider<Example>(
  create: (_) => Example(),
  // Will throw a ProviderNotFoundError, because `context` is associated
  // to the widget that is the parent of `Provider<Example>`
  child: Text(context.watch<Example>().toString()),
 );
}
```


## 해결 코드
```dart
  Widget build(BuildContext context) {
  return Provider<Example>(
    create: (_) => Example(),
    // we use `builder` to obtain a new `BuildContext` that has access to the provider
    builder: (context, child) {
    // No longer throws
  return Text(context.watch<Example>().toString()); 
  }
);
}
```
- context로 접근하려는 위젯이 있다면 child로 리턴하지말고 builder 메소드에서 리턴을 해야됨
- child로 러틴하면 `Provider`에서 관리하는 `context`에 접근하는 것이 아니라 StateFullWidget 또는 StatlessWidget에서 관리하는 context에 접근하기 때문에 당연히 오류가 발생할 수 없음


## 전체 코드

### ViewModel
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

### View
```dart
class CounterScreen2 extends StatelessWidget {
  const CounterScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("CounterScreen 2 build area rebuilded");
    return ChangeNotifierProvider(
      create: (_) => CounterViewModel(),
      child: Consumer(
        builder: (BuildContext context, CounterViewModel vm, Widget? child ) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("About ProviderFoundException"),
            ),
            body: Center(
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    const Text('Understanding ProviderFoundException'),
                    const SizedBox(height: 10),
                    Text(
                      vm.count.toString(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                    // const CounterView(),
                    // const CounterView(),
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
        },
      ),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Nested Counter View ==> ${context.read<int>()}');
  }
}

```

- `Consumer` 위젯과 같이 쓰면 `ChangeNotfierProvider` 에 `builder`을 생략하고 `child`을 속성으로 Widget을 리턴을 사용해도 무방함
- `Consumer`에서도 builder 패턴을 쓰고 있기 때문에 가능
```dart
Widget build(BuildContext context) {
  print("CounterScreen 2 build area rebuilded");
  return ChangeNotifierProvider(
    create: (_) => CounterViewModel(),
    child: Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("About ProviderFoundException"),
        ),
        body: Center(
          child: FittedBox(
            child: Column(
              children: <Widget>[
                const Text('Understanding ProviderFoundException'),
                const SizedBox(height: 10),
                Text(
                  context.watch<CounterViewModel>().count.toString(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                // const CounterView(),
                // const CounterView(),
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
    }),
  );
} 
```

- 즉 어떤 위젯이던, 위에 코드처럼 `builder pattern` 으로 구성되어 있는 Widget으로 하위 위젯을 감싸면  `ProviderNotFountException`의 세번째 대표 오류 상황을 회피할 수 있음.
- 다시 설명하자면 `Provider` context을 받기 위해 builder pattern을 적용한다고 이해할 수 있음
