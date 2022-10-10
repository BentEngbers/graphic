import 'package:graphic/src/dataflow/operator.dart';

typedef RangeUpdater<V> = V Function(
    V initialValue, V preValue, List<double> range);

/// The operator to update a value by a signal.
///
/// The operator value is the updated value.
class RangeUpdateOp<V> extends Operator<V> {
  RangeUpdateOp(Map<String, dynamic> params) : super(params);

  @override
  V evaluate() {
    final update = params['update'] as RangeUpdater<V>;
    final initialValue = params['initialValue'] as V;
    final range = params['range'] as List<double>;

    if (value == null || range == null) {
      // When the value has not been initialized or the evaluation is triggered
      // by initialValue change.

      return initialValue;
    }

    return update(initialValue, value as V, range);
  }
}
