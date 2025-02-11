import 'xyz.dart';
import '../dxf.dart';

class DxfPoint extends DxfXyz {
  DxfPoint.init(super.codes) : super.init();
  factory DxfPoint.from(List<Code> codes) {
    var entity = DxfPoint.init(codes);
    entity.setCodes(codes);
    return entity;
  }

  DxfPoint(
    DXF dxf, {
    String layerName = '0',
    double x = 0,
    double y = 0,
    double z = 0,
  }) : super(dxf, 'POINT', layerName, 'AcDbPoint', x, y, z, []);
}
