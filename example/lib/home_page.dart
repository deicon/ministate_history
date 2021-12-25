import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ministate_history/history_state_holder.dart';
import 'package:ministate_history/storage/default_history_storage.dart';
import 'package:ministate/ministate.dart';

// create Some State
class SomeState extends Equatable {
  final int counter;

  const SomeState(this.counter);
  @override
  List<Object?> get props => [counter];
}

// Some class used as Service it needed
class BackendService {
  void saveState(SomeState state) {
    // magically save state in some storage
  }

  Future<SomeState> retrieveLastState() async {
    return const SomeState(0);
  }
}

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

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateholder = stateHolder<CounterStateHolder>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // make sure the state triggers rendering once changed
            // by using the MiniStateBuilder
            MiniStateBuilder<CounterStateHolder, SomeState>(
                builder: (ctx, value, stateHolder, child) {
              return Text(
                '${value.counter}',
                style: Theme.of(context).textTheme.headline4,
              );
            })
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            stateholder.decrement();
          },
          child: const Text("-"),
        ),
        ElevatedButton(
          onPressed: () {
            stateholder.increment();
          },
          child: const Text("+"),
        ),
        ElevatedButton(
          onPressed: () {
            stateholder.increment(increment: 3);
          },
          child: const Text("+3"),
        ),
        ElevatedButton(
          onPressed: () {
            stateholder.increment(increment: 5);
          },
          child: const Text("+5"),
        ),
        ElevatedButton(
          onPressed: () {
            stateholder.undo();
          },
          child: const Text("UNDO"),
        ),
        ElevatedButton(
          onPressed: () {
            stateholder.redo();
          },
          child: const Text("REDO"),
        )
      ],
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
