import 'package:graphic/src/event/selection/select.dart';
import 'package:graphic/src/event/signal.dart';
import 'package:graphic/src/dataflow/tuple.dart';
import 'package:graphic/src/util/assert.dart';

import 'single_variable.dart';

class SizeAttr<D> extends SingleVariableAttr<double> {
  SizeAttr({
    double? value,
    String? variable,
    List<double>? values,
    List<double>? range,
    double Function(Tuple)? encode,
    Signal<double>? signal,
    Map<Select, SelectUpdate<double>>? select,
  })
    : assert(isSingle([value, variable, encode])),
      super(
        value: value,
        variable: variable,
        values: values,
        range: range,
        encode: encode,
        signal: signal,
        select: select,
      );
}
