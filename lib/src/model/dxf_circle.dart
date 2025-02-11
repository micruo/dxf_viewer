import 'dart:ui';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';

class DxfCircle extends DxfXyz {
  double _radius = 0;

  double get radius => _radius;
  set radius(double value) {
    setCode(40, value);
    _radius = value;
  }

  DxfCircle.init(super.codes) : super.init();

  factory DxfCircle.from(List<Code> codes) {
    var entity = DxfCircle.init(codes);
    entity.setCodes(codes);
    entity._radius = entity.getCode(40);
    return entity;
  }

  DxfCircle(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    double radius = 0,
  })  : _radius = radius,
        super(dxf, 'CIRCLE', layerName, 'AcDbCircles', x, y, z,
            [Code(40, radius)]);
  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) =>
      canvas.drawCircle(Offset(coord.x, coord.y), _radius, paint);
}
