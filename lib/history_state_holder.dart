import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ministate/state/default_state_holder.dart';
import 'package:ministate_history/ministate_history.dart';

class HistoryStateHolder<STATE, SERVICE extends Object>
    extends DefaultStateHolder<STATE, SERVICE> {
  final HistoryStorage history;
  HistoryStateHolder(STATE value, this.history) : super(value);

  @override
  void setState(STATE nextValue) {
    // save current as history
    history.add(value);
    super.setState(nextValue);
  }

  void redo() {
    history.redo().then((value) {
      if (value != null) {
        // take undo value as current
        history.add(this.value, clearUndo: false);
        this.value = value;
        notifyListeners();
      }
    });
  }

  void undo() {
    history.undo(value).then((v) {
      if (v != null) {
        // take undo value as current
        value = v;
        notifyListeners();
      }
    });
  }
}
