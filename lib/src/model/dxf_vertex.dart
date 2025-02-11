import 'xyz.dart';
import '../dxf.dart';

class DxfVertex extends DxfXyz {
  DxfVertex.fromDouble(DXF dxf, double x, double y, double z, String layerName)
      : super(dxf, 'VERTEX', layerName, 'AcDbVertex', x, y, z, []);
  DxfVertex.init(super.codes) : super.init();
  factory DxfVertex.from(List<Code> codes) {
    var entity = DxfVertex.init(codes);
    entity.setCodes(codes);
    return entity;
  }
}
