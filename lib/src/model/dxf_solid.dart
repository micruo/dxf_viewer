import 'xyz.dart';
import '../dxf.dart';

class DxfSolid extends DxfXyz {
  double _x1 = 0;
  double _y1 = 0;
  double _z1 = 0;
  double _x2 = 0;
  double _y2 = 0;
  double _z2 = 0;
  double _x3 = 0;
  double _y3 = 0;
  double _z3 = 0;

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

  double get x2 => _x2;
  set x2(double value) {
    setCode(12, value);
    _x2 = value;
  }

  double get y2 => _y2;
  set y2(double value) {
    setCode(22, value);
    _y2 = value;
  }

  double get z2 => _z2;
  set z2(double value) {
    setCode(32, value);
    _z2 = value;
  }

  double get x3 => _x3;
  set x3(double value) {
    setCode(13, value);
    _x3 = value;
  }

  double get y3 => _y3;
  set y3(double value) {
    setCode(23, value);
    _y3 = value;
  }

  double get z3 => _z3;
  set z3(double value) {
    setCode(33, value);
    _z3 = value;
  }

  DxfSolid.init(super.codes) : super.init();

  factory DxfSolid.from(List<Code> codes) {
    var entity = DxfSolid.init(codes);
    entity.setCodes(codes);
    entity._x1 = entity.getCode(11);
    entity._y1 = entity.getCode(21);
    entity._z1 = entity.getCode(31);
    entity._x2 = entity.getCode(12);
    entity._y2 = entity.getCode(22);
    entity._z2 = entity.getCode(32);
    entity._x3 = entity.getCode(13);
    entity._y3 = entity.getCode(23);
    entity._z3 = entity.getCode(33);
    return entity;
  }

  DxfSolid(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    double x1 = 0,
    double y1 = 0,
    double z1 = 0,
    double x2 = 0,
    double y2 = 0,
    double z2 = 0,
    double x3 = 0,
    double y3 = 0,
    double z3 = 0,
  })  : _x1 = x1,
        _y1 = y1,
        _z1 = z1,
        _x2 = x2,
        _y2 = y2,
        _z2 = z2,
        _x3 = x3,
        _y3 = y3,
        _z3 = z3,
        super(dxf, 'SOLID', layerName, 'AcDbTrace', x, y, z, [
          Code(11, x1),
          Code(21, y1),
          Code(31, z1),
          Code(12, x2),
          Code(22, y2),
          Code(32, z2),
          Code(13, x3),
          Code(23, y3),
          Code(33, z3)
        ]);
}
