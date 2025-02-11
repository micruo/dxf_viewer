import 'dart:ui';

import 'package:dxf_viewer/src/sections/blocks.dart';

import 'xyz.dart';
import '../dxf.dart';

class DxfEllipse extends DxfXyz {
  double _minorToMajorRatio = 0;
  double _xEndPoint = 0;
  double _yEndPoint = 0;
  double _zEndPoint = 0;
  double _start = 0;
  double _end = 0;

  double get minorToMajorRatio => _minorToMajorRatio;
  set minorToMajorRatio(double value) {
    setCode(40, value);
    _minorToMajorRatio = value;
  }

  double get xEndPoint => _xEndPoint;
  set xEndPoint(double value) {
    setCode(11, value);
    _xEndPoint = value;
  }

  double get yEndPoint => _yEndPoint;
  set yEndPoint(double value) {
    setCode(21, value);
    _yEndPoint = value;
  }

  double get zEndPoint => _zEndPoint;
  set zEndPoint(double value) {
    setCode(31, value);
    _zEndPoint = value;
  }

  double get start => _start;
  set start(double value) {
    setCode(41, value);
    _start = value;
  }

  double get end => _end;
  set end(double value) {
    setCode(42, value);
    _end = value;
  }

  DxfEllipse.init(super.codes) : super.init();

  factory DxfEllipse.from(List<Code> codes) {
    var entity = DxfEllipse.init(codes);
    entity.setCodes(codes);
    entity._xEndPoint = entity.getCode(11);
    entity._yEndPoint = entity.getCode(21);
    entity._zEndPoint = entity.getCode(31);
    entity._minorToMajorRatio = entity.getCode(40);
    entity._start = entity.getCode(41);
    entity._end = entity.getCode(42);
    return entity;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    // implement calcBoundaries
    super.calcBoundaries(blocks, b, off);
  }

  /// Create Ellipse entity.
  DxfEllipse(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
    double minorToMajorRatio = 0,
    double start = 0,
    double end = 0,
    double xEndPoint = 0,
    double yEndPoint = 0,
    double zEndPoint = 0,
  })  : _minorToMajorRatio = minorToMajorRatio,
        _xEndPoint = xEndPoint,
        _yEndPoint = yEndPoint,
        _zEndPoint = zEndPoint,
        _start = start,
        _end = end,
        super(dxf, 'ELLIPSE', layerName, 'AcDbEllipse', x, y, z, [
          Code(40, minorToMajorRatio),
          Code(41, start),
          Code(42, end),
          Code(11, xEndPoint),
          Code(21, yEndPoint),
          Code(31, zEndPoint),
        ]);
}
