import 'dart:ui';
import '../sections/blocks.dart';
import '../dxf.dart';

class DxfEntity {
  /// Group Codes in DXF Files
  final List<Code> _codes;

  String _type = '';
  String _layerName = '0';

  /// DXF handle
  ///
  /// A handle in a DXF file is a distinct hexadecimal identifier assigned to each entity within the drawing.
  String get handle => Code.search(_codes, 5).value;

  /// Type of entity
  ///
  /// ARC | CIRCLE | ELLIPSE | LINE | LWPOLYLINE | MTEXT | POINT | POLYLINE | SOLID | TEXT
  String get type => _type;

  /// Write to DXF file
  void write(StringSink s) {
    for (Code g in _codes) {
      g.write(s);
    }
  }

  /// DXF layer
  String get layerName => _layerName;
  set layerName(String value) {
    _layerName = value;
    setCode(8, value);
  }

  /// return the value of first Code with code = 'code'
  dynamic getCode(int code) => Code.search(_codes, code).value;

  /// set the value of first Code with code = 'code'
  void setCode(int code, dynamic value) =>
      Code.search(_codes, code).value = value;

  /// return all the codes
  get codes => _codes;

  /// create an empty DxfEntity
  DxfEntity.init(this._codes) {
    _layerName = getCode(8);
    _type = getCode(0);
  }

  /// create a DxfEntity with codes
  factory DxfEntity.from(List<Code> codes) {
    return DxfEntity.init(codes);
  }

  /// create a new DxfEntity
  DxfEntity(DXF dxf, this._type, this._layerName, List<Code> addGroups,
      [String? ref])
      : _codes = [
          Code(0, _type),
          Code(5, dxf.newHandle),
          Code(330, ref ?? dxf.modelSpace),
          Code(100, 'AcDbEntity'),
          Code(8, _layerName)
        ].followedBy(addGroups).toList();
  void calcBoundaries(BlocksSection blocks, Bounds b, Vector off) {}
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) {}
}
