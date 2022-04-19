
import 'package:test_project/undoRedo/lib/src/undo_stack.dart';

class SimpleStack<T> extends ChangeStack {
  /// Simple stack for keeping track of changes and easy callback for new state changes
  SimpleStack(
    this._state, {
    int? limit,
    this.onUpdate,
  }) : super(limit: limit) {
    if (onUpdate != null) {
      onUpdate!(_state);
    }
  }

 late T _state;

  /// Current state
  T get state => _state;

  set state(T val) => modify(val);

  void Function(T val)? onUpdate;

  void modify(T val) {
    add(Change<T>(
        _state,
        () => _newValue(val),
        _newValue,
      ));
  }

  void _newValue(T val) {
    _state = val;

    if (onUpdate != null) {
      onUpdate!(val);
    }
  }
}