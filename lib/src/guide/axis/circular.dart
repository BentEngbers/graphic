import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphic/src/common/label.dart';
import 'package:graphic/src/common/styles.dart';
import 'package:graphic/src/coord/polar.dart';
import 'package:graphic/src/graffiti/figure.dart';
import 'package:graphic/src/util/math.dart';
import 'package:graphic/src/util/path.dart';

import 'axis.dart';

List<Figure>? drawCircularAxis(
  List<TickInfo> ticks,
  double position,
  bool flip,
  StrokeStyle? line,
  PolarCoordConv coord,
) {
  final rst = <Figure>[];

  final flipSign = flip ? -1 : 1;
  final r = coord.radius * position;

  if (line != null) {
    rst.add(PathFigure(
      Path()..addArc(
        Rect.fromCircle(center: coord.center, radius: r),
        coord.startAngle,
        coord.endAngle - coord.startAngle,
      ),
      line.toPaint()
        ..style = PaintingStyle.stroke,
    ));
  }

  for (var tick in ticks) {
    // Polar coord dose not has tickLine.
    assert(tick.tickLine == null);

    final angle = coord.convertAngle(tick.position);
    if (angle >= coord.startAngle && angle <= coord.endAngle) {
      if (tick.label != null) {
        final labelAnchor = coord.polarToOffset(angle, r);
        Alignment align;
        // According to anchor's quadrant.
        final anchorOffset = labelAnchor - coord.center;
        align = Alignment(
          anchorOffset.dx.equalTo(0)
            ? 0
            : anchorOffset.dx / anchorOffset.dx.abs() * flipSign,
          anchorOffset.dy.equalTo(0)
            ? 0
            : anchorOffset.dy / anchorOffset.dy.abs() * flipSign,
        );
        rst.add(drawLabel(
          Label(tick.text, tick.label!),
          labelAnchor,
          align,
        ));
      }
    }
  }

  return rst.isEmpty ? null : rst;
}

List<Figure>? drawCircularGrid(
  List<TickInfo> ticks,
  PolarCoordConv coord,
) {
  final rst = <Figure>[];

  for (var tick in ticks) {
    if (tick.grid != null) {
      final angle = coord.convertAngle(tick.position);
      if (angle >= coord.startAngle && angle <= coord.endAngle) {
        rst.add(PathFigure(
          Paths.line(
            from: coord.polarToOffset(angle, coord.innerRadius),
            to: coord.polarToOffset(angle, coord.radius),
          ),
          tick.grid!.toPaint(),
        ));
      }
    }
  }

  return rst.isEmpty ? null : rst;
}
