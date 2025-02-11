import 'dart:ui';
import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_entity.dart';

abstract class DxfXyz extends DxfEntity {
  double _x = 0;
  double _y = 0;
  double _z = 0;

  DxfXyz(DXF dxf, String type, String layerName, String marker, double x,
      double y, double z, List<Code> addGroups)
      : _x = x,
        _y = y,
        _z = z,
        super(
            dxf,
            type,
            layerName,
            [Code(100, marker), Code(10, x), Code(20, y), Code(30, z)]
                .followedBy(addGroups)
                .toList());

  double get x => _x;
  set x(double value) {
    setCode(10, value);
    _x = value;
  }

  double get y => _y;
  set y(double value) {
    setCode(20, value);
    _y = value;
  }

  double get z => _z;
  set z(double value) {
    setCode(30, value);
    _z = value;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    if (_x + off.dx < b.minX) {
      b.minX = _x + off.dx;
    }
    if (_y + off.dy < b.minY) {
      b.minY = _y + off.dy;
    }
    if (_x + off.dx > b.maxX) {
      b.maxX = _x + off.dx;
    }
    if (_y + off.dy > b.maxY) {
      b.maxY = _y + off.dy;
    }
  }

  DxfXyz.init(super.codes) : super.init();

  setCodes(List<Code> codes) {
    _x = getCode(10);
    _y = getCode(20);
    _z = getCode(30);
  }
}
