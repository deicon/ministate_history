// History entries can be persisted
// using History Storage Services
abstract class HistoryStorage<T> {
  // add [nextValue] to History Storage
  Future<void> add(T nextValue, {bool clearUndo = true});

  Future<T?> undo(T undo);

  Future<T?> redo();

  // read last n [items] from History storage
  Future<List<T>> getHistory({int items = 10});

  // clear storage
  Future<bool> clear();
}
