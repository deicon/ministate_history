import 'package:example/home_page.dart';
import 'package:example/main_screen.dart';
import 'package:example/todo/state/todo_list_state_holder.dart';
import 'package:example/todo/state/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:ministate/ministate.dart';

void main() {
  // register all StateHolders and their needed Services before
  // Start of the App
  registerState(CounterStateHolder(const SomeState(0)), BackendService());
  registerState(TodoListsStateHolder(const TodoLists([])), NoOpService());
  // and finally run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MainScreen(),
    );
  }
}
