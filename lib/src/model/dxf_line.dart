import 'dart:ui';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';

class DxfLine extends DxfXyz {
  Vector _coord1 = Vector();
  Vector get coord1 => _coord1;
  set x1(double value) {
    setCode(11, value);
    _coord1.x = value;
  }

  set y1(double value) {
    setCode(21, value);
    _coord1.y = value;
  }

  set z1(double value) {
    setCode(31, value);
    _coord1.z = value;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Vector off) {
    super.calcBoundaries(blocks, b, off);
    if (_coord1.x + off.x < b.min.x) {
      b.min.x = _coord1.x + off.x;
    }
    if (_coord1.y + off.y < b.min.y) {
      b.min.y = _coord1.y + off.y;
    }
    if (_coord1.z + off.z < b.min.z) {
      b.min.z = _coord1.z + off.z;
    }
    if (_coord1.x + off.x > b.max.x) {
      b.max.x = _coord1.x + off.x;
    }
    if (_coord1.y + off.y > b.max.y) {
      b.max.y = _coord1.y + off.y;
    }
    if (_coord1.z + off.z > b.max.z) {
      b.max.z = _coord1.z + off.z;
    }
  }

  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) => canvas
      .drawLine(Offset(coord.x, coord.y), Offset(_coord1.x, _coord1.y), paint);

  DxfLine.init(super.codes) : super.init();

  factory DxfLine.from(List<Code> codes) {
    var entity = DxfLine.init(codes);
    entity.setCodes(codes);
    entity._coord1 =
        Vector.from(entity.getCode(11), entity.getCode(21), entity.getCode(31));
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
  })  : _coord1 = Vector.from(x1, y1, z1),
        super(dxf, 'LINE', layerName, 'AcDbLine', x, y, z, [
          Code(11, x1),
          Code(21, y1),
          Code(31, z1),
        ]);
}
