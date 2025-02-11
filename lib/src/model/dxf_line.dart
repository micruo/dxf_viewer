import 'dart:ui';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';

class DxfLine extends DxfXyz {
  double _x1 = 0;
  double _y1 = 0;
  double _z1 = 0;

  double get x1 => _x1;
  set x1(double value) {
    setCode(11, value);
    _x1 = value;
  }

  double get y1 => _y1;
  set y1(double value) {
    setCode(21, value);
    _y1 = value;
  }

  double get z1 => _z1;
  set z1(double value) {
    setCode(31, value);
    _z1 = value;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    super.calcBoundaries(blocks, b, off);
    if (_x1 + off.dx < b.minX) {
      b.minX = _x1 + off.dx;
    }
    if (_y1 + off.dy < b.minY) {
      b.minY = _y1 + off.dy;
    }
    if (_x1 + off.dx > b.maxX) {
      b.maxX = _x1 + off.dx;
    }
    if (_y1 + off.dy > b.maxY) {
      b.maxY = _y1 + off.dy;
    }
  }

  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) =>
      canvas.drawLine(Offset(x, y), Offset(_x1, _y1), paint);

  DxfLine.init(super.codes) : super.init();

  factory DxfLine.from(List<Code> codes) {
    var entity = DxfLine.init(codes);
    entity.setCodes(codes);
    entity._x1 = entity.getCode(11);
    entity._y1 = entity.getCode(21);
    entity._z1 = entity.getCode(31);
    return entity;
  }
  DxfLine(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    double x1 = 0,
    double y1 = 0,
    double z1 = 0,
  })  : _x1 = x1,
        _y1 = y1,
        _z1 = z1,
        super(dxf, 'LINE', layerName, 'AcDbLine', x, y, z, [
          Code(11, x1),
          Code(21, y1),
          Code(31, z1),
        ]);
}
