<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

As an addition to the minimalistic state manager ministate, this plugin adds history to the mix.
State mutations can be reverted and redone using the most minimakistic approach possible.
To achieve Undo/Redo capabilities on any _StateHolder_ states are kept in a size limited _HistoryStorage_ which is basically a Stack of all last states. As long as states are immutable, 
undo simply takes the last known state from the stack and uses it as the next current value. And also keeps the currently active state as the next redo state. 
This approach basically implements the [Memento Pattern](https://en.wikipedia.org/wiki/Memento_pattern). 

Using this pattern, each state change can simply be undone by just returning back to the previous state. So even changes, which would not be easily revertable (i.e. hashing) can be undone using this approach. 
Be aware, that the size of the state as well as the size of the undo history increases the memory footprint of the app, as all states are kept completely in the history storage. 

### Create some State class
The state class will be holding some or even all
of the apps state. In order to distinguish new from old states, make sure states can be compared 
for equality. 

````dart
// create Some State
class SomeState extends Equatable {
  final int counter;

  const SomeState(this.counter);
  @override
  List<Object?> get props => [counter];
}
````

### Define a StateHolder and Service
To separate logic, state and persistence, each State will be handled by a StateHolder class which in turn knows which Service to use for Persistence. 

So first define a Service class. This should be the place to talk to backend services or do local 
persistence on the device. 

```dart
class BackendService {
  void saveState() {
    // magically save state in some storage
  }

  Future<SomeState> retrieveLastState() async {
    // maybe save it to sqlite or firebase
    return const SomeState(0);
  }
}
```

Then the StateHolder class to bind it all together. StateHolder class is derived from _HistoryStateHolder and typed with the _StateClass_ as well as the _Service_ classname.

Stateholder 

1. holds the state
2. provides mutation methods to be used anywhere
3. Is responsible to keep undo/redo history 
4. knows how to notify rendering widgets of changes

```dart
// Define the StateHolder and derive from GetItStateHolder
class CounterStateHolder extends HistoryStateHolder<SomeState, BackendService> {
  CounterStateHolder(SomeState value)
      : super(value, DefautHistoryStorage<SomeState>(5));

  // define mutation methods
  void increment({int increment = 1}) {
    // create new state derive from old value/state
    // calling setState triggers re rendering
    var nextState = SomeState(value.counter + increment);
    setState(nextState);
  }

  void decrement({int decrement = 1}) {
    // create new state derive from old value/state
    // calling setState triggers re rendering
    setState(SomeState(value.counter - decrement));
  }
}
```

## Usage
Once all needed classes are set up, make sure to 
register all _StateHolder_ with their _Serives_ at start of 
the main app. 

```dart 

void main() {
  // register all StateHolders and their needed Services before
  // Start of the App
  registerState(CounterStateHolder(const SomeState(0)), BackendService());

  // and finally run the app
  runApp(const MyApp());
}
```

To display states and react on state changes use 

```dart
// access Stateholder anywhere in the code 
// using provided stateHolder<> method
var stateholder = stateHolder<CounterStateHolder>();
...
MiniStateBuilder<CounterStateHolder, SomeState>(
        listener: (context, value) {
            // react here on specific states just before rendering the
            // new state
            if (value.counter == 10) {
                // reset by explicitly setting states value
                // told ya. minimalistic approach.
                stateholder.setState(const SomeState(0));
            }
        }, 
        builder: (ctx, value, stateHolder, child) {
            return Text(
            '${value.counter}',
            style: Theme.of(context).textTheme.headline4,
            );
        })
...
```

As the _StateHolder_ is available anywhere using LocatorPattern, one can simply use it in any action handler to mutate state. Here we can now simply undo and redo changes

```dart
ElevatedButton(
    onPressed: () {
    stateHolder<CounterStateHolder>().decrement();
    },
    child: const Text("-"),
),
ElevatedButton(
    onPressed: () {
    stateHolder<CounterStateHolder>().undo();
    },
    child: const Text("UNDO"),
),
ElevatedButton(
    onPressed: () {
    stateHolder<CounterStateHolder>().redo();
    },
    child: const Text("REDO"),
)
```