import 'dart:ui';
import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_entity.dart';

class DxfLwPolyline extends DxfEntity {
  List<Offset> _vertices = [];
  bool _isClosed = false;

  List<Offset> get vertices => _vertices;
  set vertices(List<Offset> value) {
    setCode(90, value.length);
    _vertices = value;
  }

  bool get isClosed => _isClosed;
  set isClosed(bool value) {
    setCode(70, value ? 1 : 0);
    _isClosed = value;
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    for (var v in _vertices) {
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

  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) {
    for (int i = 0; i < _vertices.length; i++) {
      canvas.drawLine(
          _vertices[i], _vertices[(i + 1) % _vertices.length], paint);
    }
  }

  DxfLwPolyline.init(super.codes) : super.init();
  factory DxfLwPolyline.from(List<Code> codes) {
    var entity = DxfLwPolyline.init(codes);
    entity._isClosed = (entity.getCode(70) == 1);

    for (var element in codes) {
      switch (element.code) {
        case 10:
          entity._vertices.add(Offset(element.value, 0));
        case 20:
          entity._vertices.last =
              Offset(entity._vertices.last.dx, element.value);
      }
    }
    return entity;
  }

  DxfLwPolyline(
    DXF dxf, {
    required List<Offset> vertices,
    String layerName = '0',
    bool isClosed = false,
  })  : _vertices = vertices,
        _isClosed = isClosed,
        super(
            dxf,
            'LWPOLYLINE',
            layerName,
            [
              Code(100, 'AcDbPolyline'),
              Code(90, vertices.length),
              Code(70, isClosed ? 1 : 0),
              Code(43, 0.0)
            ]
                .followedBy(
                    vertices.expand((e) => [Code(10, e.dx), Code(20, e.dy)]))
                .toList());
}
