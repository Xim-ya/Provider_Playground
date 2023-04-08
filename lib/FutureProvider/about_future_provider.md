## FutureProvider
위젯트리는 이미 빌드가 되어 있는 상황에서 비동기적으로 위젯이 빌드가 되어야 할 때 사용
### 원형
```dart
FutureProvider(
    Key? key,
    required Create<Future<T>?> create, 
    reqruied T initialData,
    ...
)
```
- initialData 값으로 기본 값을 설정해야됨
  - Future가 resolve되기 전에 initialData가 보여짐
- create문에서 Future 타입의 값을 리턴
- FutureBuilder와 쓰임새가 비슷함
- 만약 여러개의 연속적인 값에 대응하고 싶으면 `StreamProvider`를 사용하면 됨


## 코드
### ViewModel
```dart
class CounterViewModel {
  Future<int> returnIncreasedValue() async {
    await Future.delayed(const Duration(seconds: 2));
    print("ACTIAVATED");
    return 1;
  }


  Future<int> returnIncreasedValue2() async {
    await Future.delayed(const Duration(seconds: 2));
    print("ACTIAVATED2");
    return 2;
  }
}
```
- ViewModel해당하는 클래스가 `ChangeNofier`를 extends 하지 않아도 동적으로 UI를 업데이트할 수 있음.


### View
```dart
class ProviderWrapper4 extends StatelessWidget {
  const ProviderWrapper4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final vm = CounterViewModel();
            return vm.returnIncreasedValue();
          },
        ),
        FutureProvider<int>(
          initialData: 0,
          create: (context) {
            final vm = CounterViewModel();
            return vm.returnIncreasedValue2();
          },
        ),
      ],
      child: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Future Provider"),
      ),
      body: Center(
        child: FittedBox(
          child: Column(
            children: <Widget>[
              const Text('You can use ethier provider.of or context extension'),
              const SizedBox(height: 10),
              Text(
                context.watch<int>().toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const CounterView(),
              // const CounterView(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, 
        child: const Icon(Icons.add),
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
- Provider.of, context extension을 사용해서 FutureProvider 인스턴스에에 접근할 수 있음.
- 만약 위처럼 `MultiProvider`에 여러 같은 타입의 여러 FutureProvider가 있다면 가장 가까운 FutureProvider의 인스턴스 값을 받아옴
   - 그렇기 때문에 보통 원시형 타입을 쓰기 보다는 Primitive한 타입을 쓰는 경우가 많음
- context extension을 이용해서 인스턴스를 받아온다면 `watch` 함수를 적용해야 됨.


## 기타
### context의 이해
위에 context extension을 적용할 때 동적으로 UI 변화를 감지하기 위해 `watch`를 써야한다.
하지만 특정 상황에서 `read` 쓸 수 있는데...

``dart
Text(
context.watch<int>().toString(),
style: Theme.of(context).textTheme.headlineLarge,
),
Text('Nested Counter View ==> ${context.read<int>()}')
``

이렇게 동일한 인스턴스를 받아오는 위젯이 있을 때 하위에 있는 인스턴스를 read로 값을 동적으로 받아올 수 있다.
물론 반대의 경우는 허용하지 않은다. 왜냐하면 하위에 트리에서의 변화가 상위 트리에로 전달 할 수 없기 때문

