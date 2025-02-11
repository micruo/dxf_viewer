import 'dart:ui';
import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_entity.dart';

class DxfSpline extends DxfEntity {
  bool _isClosed = false;
  int _degree = 3;
  List<double> _knots = <double>[];
  List<Offset> _controlPoints = [];
  bool get isClosed => _isClosed;
  set isClosed(bool value) {
    setCode(70, value ? 1 : 0);
    _isClosed = value;
  }

  int get degree => _degree;
  set degree(int value) {
    setCode(71, value);
    _degree = value;
  }

  List<double> get knots => _knots;
  set knots(List<double> value) {
    setCode(72, value.length);
    _knots = value;
  }

  List<Offset> get controlPoints => _controlPoints;
  set controlPoints(List<Offset> value) {
    setCode(73, value.length);
    _controlPoints = value;
  }

  DxfSpline.init(super.codes) : super.init();
  factory DxfSpline.from(List<Code> codes) {
    var entity = DxfSpline.init(codes);
    entity._isClosed = (entity.getCode(70) == 1);
    entity._degree = entity.getCode(71);

    for (var element in codes) {
      switch (element.code) {
        case 10:
          entity._controlPoints.add(Offset(element.value, 0));
        case 20:
          entity._controlPoints.last = Offset(entity._controlPoints.last.dx, element.value);
        case 40:
          entity._knots.add(element.value);
      }
    }
    return entity;
  }
  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    for (var v in _controlPoints) {
      Offset o = v + off;
      if (o.dx < b.minX) {
        b.minX = o.dx;
      }
      if (o.dy < b.minY) {
        b.minY = o.dy;
      }
      if (o.dx > b.maxX) {
        b.maxX = o.dx;
      }
      if (o.dy > b.maxY) {
        b.maxY = o.dy;
      }
    }
  }

  DxfSpline(
    DXF dxf, {
    required List<Offset> controlPoints,
    String layerName = '0',
    bool isClosed = false,
    int degree = 3,
    required List<double> knots,
  })  : _controlPoints = controlPoints,
        _isClosed = isClosed,
        _degree = degree,
        _knots = knots,
        super(
            dxf,
            'SPLINE',
            layerName,
            [
              Code(100, 'AcDbSpline'),
              Code(70, isClosed ? 1 : 8),
              Code(71, degree),
              Code(72, knots.length),
              Code(73, controlPoints.length),
              Code(43, 0.0)
            ]
                .followedBy(knots.map((e) => Code(40, e)))
                .followedBy(controlPoints.expand((e) => [Code(10, e.dx), Code(20, e.dy)]))
                .toList());
}
