import 'dart:math';

import 'history_storage.dart';

class DefautHistoryStorage<T> extends HistoryStorage<T> {
  final List<T> _history;
  final List<T> _undoList = [];
  final int maxSize;
  final Future<void> Function(List<T>)? persistenceHandler;

  DefautHistoryStorage(this.maxSize, {this.persistenceHandler})
      : _history = <T>[];

  @override
  Future<void> add(T nextValue, {bool clearUndo = true}) async {
    if (_history.length == maxSize) {
      _history.remove(_history.first);
    }
    _history.add(nextValue);
    // if one new is added, the undo is invalid
    if (clearUndo) _undoList.clear();
    await notifyPersistence();
  }

  @override
  Future<bool> clear() async {
    _history.clear();
    _undoList.clear();
    await notifyPersistence();
    return true;
  }

  @override
  Future<List<T>> getHistory({int items = 10}) async {
    if (_history.isEmpty) return [];
    return _history.reversed
        .toList()
        .getRange(0, min(items, _history.length))
        .toList();
  }

  Future<void> notifyPersistence() async {
    if (persistenceHandler != null) {
      persistenceHandler!.call(_history);
    }
  }

  @override
  Future<T?> redo() async {
    if (_undoList.isNotEmpty) {
      var last = _undoList.removeLast();
      return last;
    }
    return null;
  }

  @override
  Future<T?> undo(T undo) async {
    if (_history.isEmpty) {
      return null;
    }
    // keep last from stack as redo
    var last = _history.removeLast();
    _undoList.add(undo);
    return last;
  }
}
