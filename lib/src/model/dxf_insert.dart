import 'dart:ui';
import 'xyz.dart';
import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_entity.dart';

class DxfInsert extends DxfXyz {
  /* Name of inserted block [#2]. */
  String _blockName = '';

/*
  /// Scaling factor in x [#41].
  double _scaleX = 1.0;

  /// Scaling factor in y [#42].
  double _scaleY = 1.0;

  /// Rotation angle [#50].
  double _rotAngle = 0.0;

  /// Number of rows [#71].
  int _nrRows = 1;

  /// Number of columns [#72].
  int _nrCols = 1;

  /// distance between rows [#44]
  double _rowDist = 0.0;

  /// distance between columns [#45]
  double _colDist = 0.0;*/

  /*
  double get scaleX => _scaleX;
  set scaleX(double value) {
    setGroup(41, value);
    _scaleX = value;
  }
  double get scaleY => _scaleY;
  set scaleY(double value) {
    setGroup(42, value);
    _scaleY = value;
  }*/

  DxfInsert.init(super.codes) : super.init();

  factory DxfInsert.from(List<Code> codes) {
    var entity = DxfInsert.init(codes);
    entity.setCodes(codes);
    entity._blockName = entity.getCode(2);
    /* entity._scaleX = entity.getGroup(41);
    entity._scaleY = entity.getGroup(42);
    entity._rotAngle = entity.getGroup(50);
    entity._nrRows = entity.getGroup(71);
    entity._nrCols = entity.getGroup(72);
    entity._rowDist = entity.getGroup(44);
    entity._colDist = entity.getGroup(45);*/
    return entity;
  }
  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    blocks.getBlockByName(_blockName).calcBoundaries(blocks, b, Offset(x, y));
  }

  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) {
    canvas.save();
    canvas.translate(x, y);
    for (DxfEntity e in blocks.getBlockByName(_blockName).entities) {
      e.draw(blocks, canvas, paint);
    }
    canvas.restore();
  }

  DxfInsert(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    required String blockName,
  })  : _blockName = blockName,
        super(dxf, 'INSERT', layerName, 'AcDbBlockReference', x, y, z, [
          Code(2, blockName),
        ]);
}
