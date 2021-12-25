import 'package:flutter_test/flutter_test.dart';

import 'package:ministate_history/ministate_history.dart';
import 'package:ministate_history/storage/default_history_storage.dart';

class TestState {
  final String name;

  TestState(this.name);
}

void main() {
  test('get history for empty hist should return null', () async {
    var storage = new DefautHistoryStorage<TestState>(10);
    var hist = await storage.getHistory(items: 10);
    expect(hist.length, 0);
  });

  test('get 10 items history for 3 item history should return 3 items',
      () async {
    var storage = new DefautHistoryStorage<TestState>(10);
    storage.add(TestState("Dieter"));
    storage.add(TestState("ist"));
    storage.add(TestState("hier"));
    var hist = await storage.getHistory(items: 10);
    expect(hist.length, 3);
  });
}
