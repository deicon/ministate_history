import 'package:equatable/equatable.dart';

class NoOpService {}

class TodoLists extends Equatable {
  final List<TodoList> lists;

  const TodoLists(this.lists);

  @override
  List<Object?> get props => [lists];
}

class TodoList extends Equatable {
  final String name;
  final List<TodoItem> items;

  const TodoList(this.name, this.items);

  @override
  List<Object?> get props => [name, items];
}

class TodoItem extends Equatable {
  final String name;
  final String description;
  final TodoStatus status;

  const TodoItem(this.name, this.description, this.status);

  factory TodoItem.nextStatus(TodoItem item, TodoStatus status) {
    return TodoItem(item.name, item.description, status);
  }

  @override
  List<Object?> get props => [name, description, status];
}

enum TodoStatus { open, progress, done, postponed }
