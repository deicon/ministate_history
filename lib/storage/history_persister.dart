// Interface for the pluggable history persister
// The persister might choose to save history data
// in persistent storage (file/db) and will be called
// to retrieve last known state of history as well as
// everytime the history is changed
abstract class HistoryPersister<T> {
  Future<List<T>> readAll();
  Future<void> updateAll(List<T> history);
}
