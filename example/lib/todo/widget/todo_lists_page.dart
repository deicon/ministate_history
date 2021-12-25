import 'dart:math';

import 'package:example/todo/state/todo_list_state_holder.dart';
import 'package:example/todo/state/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:ministate/ministate.dart';

class TodoListsPage extends StatelessWidget {
  const TodoListsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stateholder = stateHolder<TodoListsStateHolder>();
    return Scaffold(
        body: MiniStateBuilder<TodoListsStateHolder, TodoLists>(
          builder: (ctx, value, holder, _) {
            return ListView.builder(
              itemCount: holder.getState().lists.length,
              itemBuilder: (ctx, index) {
                return Text(holder.getState().lists[index].name);
              },
            );
          },
        ),
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () {
              stateholder.addList("Demo_${Random().nextInt(100)}");
            },
            child: const Text("+"),
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
        ]);
  }
}
