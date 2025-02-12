import 'set.dart';
import '../dxf.dart';

/// OBJECTS Section
///
/// The OBJECTS section of a DXF™ file contains group codes for nongraphical objects.
/// These codes are utilized by AutoLISP® and ObjectARX® applications to define entities.

class ObjectsSection extends Section {
  ObjectsSection();

  /// create an ObjectsSection from DXF codes
  factory ObjectsSection.from(List<Code> codes) {
    var section = ObjectsSection();
    section.from(codes);
    return section;
  }
}
