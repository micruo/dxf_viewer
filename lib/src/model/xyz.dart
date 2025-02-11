import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_entity.dart';

abstract class DxfXyz extends DxfEntity {
  Vector _coord = Vector();

  /// create a new DxfXyz
  DxfXyz(DXF dxf, String type, String layerName, String marker, double x,
      double y, double z, List<Code> addGroups)
      : _coord = Vector.from(x, y, z),
        super(
            dxf,
            type,
            layerName,
            [Code(100, marker), Code(10, x), Code(20, y), Code(30, z)]
                .followedBy(addGroups)
                .toList());

  /// returns the coordinate
  Vector get coord => _coord;

  /// set x coordinate
  set x(double value) {
    setCode(10, value);
    _coord.x = value;
  }

  /// set y coordinate
  set y(double value) {
    setCode(20, value);
    _coord.y = value;
  }

  /// set z coordinate
  set z(double value) {
    setCode(30, value);
    _coord.z = value;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Vector off) {
    if (_coord.x + off.x < b.min.x) {
      b.min.x = _coord.x + off.x;
    }
    if (_coord.y + off.y < b.min.y) {
      b.min.y = _coord.y + off.y;
    }
    if (_coord.z + off.z < b.min.z) {
      b.min.z = _coord.z + off.z;
    }
    if (_coord.x + off.x > b.max.x) {
      b.max.x = _coord.x + off.x;
    }
    if (_coord.y + off.y > b.max.y) {
      b.max.y = _coord.y + off.y;
    }
    if (_coord.z + off.z > b.max.z) {
      b.max.z = _coord.z + off.z;
    }
  }

  DxfXyz.init(super.codes) : super.init();

  setCodes(List<Code> codes) {
    _coord = Vector.from(getCode(10), getCode(20), getCode(30));
  }
}
