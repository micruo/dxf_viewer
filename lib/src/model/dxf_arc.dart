import 'dart:ui';
import 'dart:math';
import '../dxf.dart';
import '../sections/blocks.dart';
import 'xyz.dart';

class DxfArc extends DxfXyz {
  double _radius = 0;
  double _startAngle = 0;
  double _endAngle = 0;

  double get radius => _radius;
  set radius(double value) {
    setCode(40, value);
    _radius = value;
  }

  double get startAngle => _startAngle;
  set startAngle(double value) {
    setCode(50, value);
    _startAngle = value;
  }

  double get endAngle => _endAngle;
  set endAngle(double value) {
    setCode(51, value);
    _endAngle = value;
  }

  DxfArc.init(super.codes) : super.init();

  factory DxfArc.from(List<Code> codes) {
    var entity = DxfArc.init(codes);
    entity.setCodes(codes);
    entity._radius = entity.getCode(40);
    entity._startAngle = entity.getCode(50);
    entity._endAngle = entity.getCode(51);
    return entity;
  }
  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) => canvas.drawArc(
      Rect.fromCircle(center: Offset(x, y), radius: _radius),
      _startAngle / 180 * pi,
      (_endAngle - _startAngle + (_endAngle < _startAngle ? 360 : 0)) /
          180 *
          pi,
      false,
      paint);

  DxfArc(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    double radius = 0,
    double startAngle = 0,
    double endAngle = 0,
  })  : _radius = radius,
        _startAngle = startAngle,
        _endAngle = endAngle,
        super(dxf, 'ARC', layerName, 'AcDbArc', x, y, z, [
          Code(40, radius),
          Code(50, startAngle),
          Code(51, endAngle),
        ]);
}
