import 'set.dart';

import '../model/dxf_entity.dart';
import '../dxf.dart';

/// ENTITIES Section
///
/// The ENTITIES section contains group codes associated with graphical elements in the drawing.
class EntitiesSection with DxfSet {
  EntitiesSection();

  factory EntitiesSection.from(List<Code> codes) {
    var section = EntitiesSection();
    section.addElements(codes, 2);
    return section;
  }

  void addEntity(DxfEntity entity) {
    entities.add(entity);
  }

  bool removeEntity(DxfEntity entity) {
    return entities.remove(entity);
  }

  DxfEntity? getEntityByHandle(String handle) {
    return entities.where((element) => element.handle == handle).firstOrNull;
  }

  void write(StringSink s) {
    s.write('  0\r\nSECTION\r\n  2\r\nENTITIES\r\n');
    for (var g in entities) {
      g.write(s);
    }
    s.write('  0\r\nENDSEC\r\n');
  }
}
