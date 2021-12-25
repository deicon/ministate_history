import 'package:example/todo/state/todo_state.dart';
import 'package:ministate_history/history_state_holder.dart';
import 'package:ministate_history/storage/default_history_storage.dart';

class TodoListsStateHolder extends HistoryStateHolder<TodoLists, NoOpService> {
  TodoListsStateHolder(TodoLists value)
      : super(value, DefautHistoryStorage(40));

  void addList(String listName) {
    // always make sure to use imutable state mutations
    setState(TodoLists([...value.lists, TodoList(listName, const [])]));
  }

  void removeList(String listName) {
    value.lists.removeWhere((element) => element.name == listName);
    setState(TodoLists([...value.lists, TodoList(listName, const [])]));
  }
}
