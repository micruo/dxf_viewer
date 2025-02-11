import 'dart:ui';
import '../sections/blocks.dart';
import '../dxf.dart';
import 'dxf_vertex.dart';
import 'dxf_entity.dart';

class DxfPolyline extends DxfEntity {
  bool _vertexFlag = true; /* vertex flag (always 1) [#66] */
  double _baseX = 0;
  double _baseY = 0;
  double _baseZ = 0;
  List<DxfVertex> _vertices = []; /* vertices of this polyline */

  set baseX(double value) {
    setCode(10, value);
    _baseX = value;
  }

  set baseY(double value) {
    setCode(20, value);
    _baseY = value;
  }

  set baseZ(double value) {
    setCode(30, value);
    _baseZ = value;
  }

  double get baseX => _baseX;
  double get baseY => _baseY;
  double get baseZ => _baseZ;
  bool get vertexFlag => _vertexFlag;
  /*
  int _typePL = 0; /* type of polyline [#70] */
  double _startWidth = 0,
      /* starting width [#40] */
      _endWidth = 0; /* ending width [#41] */
  int _nrCtrlU = 0,
      /* number of control points in U dir [#71] */
      _nrCtrlV = 0; /* number of control points in V dir [#72] */
  int _nrApproxM = 0,
      /* approximation points in M dir [#73] */
      _nrApproxN = 0; /* approximation points in N dir [#74] */
  int _smooth = 0; /* type of smoothing [#75] */
*/

  DxfPolyline.init(super.codes) : super.init();

  factory DxfPolyline.from(List<Code> codes) {
    var entity = DxfPolyline.init(codes);
    entity._baseX = entity.getCode(10);
    entity._baseY = entity.getCode(20);
    entity._baseZ = entity.getCode(30);
    entity._vertexFlag = (entity.getCode(66) == 1);
    return entity;
  }
  void addVertex(List<Code> codes) {
    _vertices.add(DxfVertex.from(codes));
  }

  @override
  void calcBoundaries(BlocksSection blocks, Bounds b, Offset off) {
    for (DxfVertex v in _vertices) {
      v.calcBoundaries(blocks, b, off);
    }
  }

  @override
  void draw(BlocksSection blocks, Canvas canvas, Paint paint) {
    for (int i = 0; i < _vertices.length; i++) {
      canvas.drawLine(
          Offset(_vertices[i].x, _vertices[i].y),
          Offset(_vertices[(i + 1) % _vertices.length].x,
              _vertices[(i + 1) % _vertices.length].y),
          paint);
    }
  }

  DxfPolyline(
    DXF dxf, {
    required List<List<double>> vertices,
    String layerName = '0',
  })  : _vertices = vertices
            .map((e) => DxfVertex.fromDouble(dxf, e[0], e[1], e[2], layerName))
            .toList(),
        super(
            dxf,
            'POLYLINE',
            layerName,
            [Code(90, vertices.length), Code(43, 0.0)]
                .followedBy(
                    vertices.expand((e) => [Code(10, e[0]), Code(20, e[1])]))
                .toList());
}
